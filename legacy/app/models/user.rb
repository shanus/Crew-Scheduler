require 'digest/sha1'
class User < ActiveRecord::Base
  belongs_to :team
  has_many :seating_positions
  has_many :events, :through => :seating_positions
  before_create :make_activation_code
  has_many :bulletins
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email, :side
  validates_inclusion_of    :side, 
                            :in => %w{ port stbd ambi },
                            :message  => "must be 'port','stbd', or 'ambi'"
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  def human_side
    hside = 'either'
    case self.side
    when "stbd" 
      hside = 'starboard'
    when "port" 
      hside = 'port'
    end
    hside
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    # hide records with a nil activated_at
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login]
    u && u.authenticated?(password) ? u : nil
  end
  
  def activate
    @activated = true
    update_attributes(:activated_at => Time.now.utc, :activation_code => nil)
  end

  def recently_activated?
    @activated
  end
  
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def name
    "#{self.login}"
  end
  
  def coxswain?
    self.will_cox
  end
  
  def coach?
    self.will_coach  
  end
  
  def public_rowing_history?
    self.public_rowing_history
  end
  
  def self.email_reminders
    @users = User.find :all, :conditions => { :send_reminders => true }
    @users.each do |user|
      # find rowing events
      @events = user.events.find :all, :conditions => ["event_on = ?", (Time.now + 1.day).strftime("%Y-%m-%d")]
      # find coaching events
      @events << Event.find(:all, :conditions => ["event_on = ? AND coach = ?", (Time.now + 1.day).strftime("%Y-%m-%d"), user.login])
      # find coxing events
      @events << Event.find(:all, :conditions => ["event_on = ? AND coxswain = ?", (Time.now + 1.day).strftime("%Y-%m-%d"), user.login])
      @events.each do |event|
        EventNotifier.deliver_reminder(event) if ((!event.eql?([])) && event.is_on?)
        #logger.info "#{event.class} #{event.is_on?}" if ((!event.eql?([])) && event.is_on?)
      end
    end
  end
  
  def upcoming
    upcoming = []
    events = self.events.find :all, :conditions => ["event_on >= ? AND event_on < ?", Date.today, (Date.today + 2.weeks)], :order => "event_on"
    events.each do |event|
      upcoming << event if event.is_on?
    end
    return upcoming
  end
  
  def reset_password
    self.password = self.random_password
    self.password_confirmation = self.password
    self.save!
  end
  
  def rowing_history(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day #set Sunday as beginning of week
    history = Array.new(time_period, 0)
    events = self.events.find :all, :conditions => ["event_on <= ? AND event_on > ?", todays_date, (start_of_week - time_period.to_i.weeks)], :order => "event_on DESC"
    events.each do |event|
      if event.is_on?
        0.upto(time_period.to_i) { |i|
          history[i] = 0 if history[i].nil?
          if (event.event_on >= start_of_week - i.weeks)
            history[i] += 1
            break
          end
        }
      end
    end
    return history
  end
  
  def completed_events(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day #set Sunday as beginning of week
    completed = []
    events = self.events.find :all, :conditions => ["event_on <= ? AND event_on > ?", todays_date, (start_of_week - time_period.to_i.weeks)], :order => "event_on DESC"
    events.each do |event|
      if event.is_on?
        completed << event
      end
    end
    return completed
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def random_password(size = 8)
      chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
      (1..size).collect{|a| chars[rand(chars.size)] }.join
    end
end
