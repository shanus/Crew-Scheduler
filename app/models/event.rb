class Event < ActiveRecord::Base
  attr_accessible :boat_id, :ends_at, :starts_at, :team_id, :coach, :coxswain, :start_date, :start_time, :end_date, :end_time
  attr_accessor :start_date, :start_time, :end_date, :end_time
  
  before_validation :make_starts_at
  before_validation :make_ends_at
  
  has_many :participations, :dependent => :destroy, :inverse_of => :event
  has_many :users, :through => :participations
  
  belongs_to :team
  belongs_to :boat
  
  validates :start_date, :event_time => true
  validates :team_id, :presence => true
  validates :boat_id, :presence => true
  
  def full?
    return false unless self.boat?
    self.users.count >= self.boat.seats
  end
  
  def nick_name
    "#{self.team ? self.team.name : 'unknown'} #{self.starts_at ? self.starts_at.strftime('%Y-%m-%d') : nil}".strip
  end
  
  def make_starts_at
    if @start_date.present? && @start_time.present?
      self.starts_at = DateTime.new(@start_date.year, @start_date.month, @start_date.day, @start_time.hour, @start_time.min)
    end
  end
  
  def make_ends_at
    if @end_date.present? && @end_time.present?
      self.ends_at = DateTime.new(@end_date.year, @end_date.month, @end_date.day, @end_time.hour, @end_time.min)
    end
  end
  
  def start_date
    return @start_date if @start_date.present?
    return @starts_at if @starts_at.present?
    return Date.tomorrow
  end
  
  def end_date
    return @end_date if @end_date.present?
    return @ends_at if @ends_at.present?
    return Date.tomorrow
  end
  
  def start_time
    return @start_time if @start_time.present?
    return @starts_at if @starts_at.present?
    return Time.now
  end
  
  def end_time
    return @end_time if @end_time.present?
    return @ends_at if @ends_at.present?
    return Time.now
  end
  
  def start_date=(new_date)
    @start_date = new_date.to_datetime
  end

  def start_time=(new_time)
    begin
      @start_time = DateTime.strptime(new_time,"%H:%M")
    rescue ArgumentError
      nil
    end
  end
  
  def end_date=(new_date)
    @end_date = new_date.to_datetime
  end

  def end_time=(new_time)
    begin
      @end_time = DateTime.strptime(new_time,"%H:%M")
    rescue ArgumentError
      nil
    end
  end
  
  def to_param
    "#{id}-#{nick_name.to_s.strip.downcase.gsub(/[^a-z0-9\-]+/, "_")}".strip
  end
end
