class Event < ActiveRecord::Base
  has_many :seating_positions
  has_many :users, :through => :seating_positions
  belongs_to :team
  belongs_to :boat
  
  validates_presence_of :boat_id
  
  def is_on?
    max_rowers = 1
    if (self.boat)
      max_rowers = self.boat.max_number_of_rowers
    end
    rowers = (self.users.count >= max_rowers)
    # coxswain required then coxswain must be filled
    coxswain = !self.needs_coxswain?
    # coach required then must have coach filled in
    coach = !self.needs_coach?
    rowers && coxswain && coach
  end
  
  def needs_coxswain?
    return true if self.team.nil?
    (self.team.require_cox && (self.coxswain.nil? || self.coxswain == ""))
  end
  
  def needs_coach?
    return true if self.team.nil?
    (self.team.require_coach && (self.coach.nil? || self.coach == ""))
  end
  
  def within_time_limit?
    day = self.event_on.strftime("%Y-%m-%d")
    hour = self.start_time.strftime("%H:%M")
    event_time = Time.parse("#{day} #{hour}")
    event_time <= (Time.now + 20.hour)
  end
  
  def self.today
    times = []
    events = find :all, :conditions => { :event_on => Date.today }, :order => "start_time"
    events.each do |event|
      times << event if event.is_on?
    end
    return times
  end
  
  def self.tomorrow
    times = []
    events = find :all, :conditions => { :event_on => Date.tomorrow }, :order => "start_time"
    events.each do |event|
      times << event if event.is_on?
    end
    return times
  end
  
  def self.day_after_tomorrow
    times = []
    events = find :all, :conditions => { :event_on => (Date.tomorrow + 1.day) }, :order => "start_time"
    events.each do |event|
      times << event if event.is_on?
    end
    return times
  end
  
  def self.needed
    needed = []
    events = find :all, :conditions => ["event_on >= ? AND event_on < ?", Date.today, (Date.today + 4.days)], :order => "event_on"
    events.each do |event|
      needed << event if (!event.is_on? && !event.within_time_limit?)
    end
    return needed    
  end
  
  def self.daily_notify
    events = Event.tomorrow
    events.each do |event|
      recipients = []
      rowers = event.users
      coach = User.find_by_login(event.coach)
      coxswain = User.find_by_login(event.coxswain)
      recipients << coach unless coach.nil? || coach.send_reminders == false
      recipients << coxswain unless coxswain.nil? || coxswain.send_reminders == false
      rowers.each do |r|
        recipients << r unless r.send_reminders == false
      end
      EventNotifier.deliver_reminder(event, recipients) unless recipients.blank?
    end
  end
  
  def self.check_start(date, start_time)
    #date = time.strftime("%Y-%m-%d")
    #start = time.strftime("%H:%M")
    case ActiveRecord::Base.connection.adapter_name
    when 'PostgreSQL'
      events = Event.find :all, :conditions => ["event_on = ? AND CAST(start_time as TEXT) LIKE '%#{start_time}%'",date]
    else
      events = Event.find :all, :conditions => ["event_on = ? AND start_time LIKE '%#{start_time}%'",date]
    end
    return [nil] unless events.size > 1
    ["#{events.size} crews are launching at the same time"]
  end
  
  def team_name
    return self.team.name unless team.nil?
    "Unknown"
  end
  
  def boat_name
    return self.boat.name unless boat.nil?
    "Unknown"
  end
  
  def rowers
    @rowers = Hash.new
    self.seating_positions.each do |seat|
      unless seat.user.nil?
        name = seat.user.login
      else
        name = nil
      end
      @rowers[seat.position] = name
    end
    @rowers
  end
  
  def start_hour_min
    self.start_time.strftime("%H:%M")
  end
  
  def end_hour_min
    self.end_time.strftime("%H:%M")
  end
  
  def coach_email
    return nil if (u = User.find(:first, :conditions => { :login => self.coach })).nil?
    nil || (u.email) unless (self.coach.nil? || self.coach == "") 
  end
  
  def coxswain_email
    return nil if (u = User.find(:first, :conditions => { :login => self.coxswain })).nil?
    nil || (u.email) unless (!self.boat.has_coxswain? || self.coxswain.nil? || self.coxswain == "")
  end
  
  def rowers_email
    self.users.collect { |u| u.email }
  end
  
  def coxswain_name
    return "none" if (self.coxswain.nil? || self.coxswain =="")
    self.coxswain
  end
  
  def coach_name
    return "none" if (self.coach.nil? || self.coach =="")
    self.coach
  end
  
  def find_rower_seat(rower)
    seat = self.seating_positions.find_by_user_id(rower)
    seat.nil? ? seat : seat.position
  end
end
