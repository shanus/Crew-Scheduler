class User < ApplicationRecord
  has_secure_password validations: false

  belongs_to :team, optional: true
  has_many :seating_positions
  has_many :events, through: :seating_positions
  has_many :bulletins

  after_create :send_signup_notification
  after_save :send_activation_notification, if: :recently_activated?

  # Virtual attribute for the unencrypted password is handled by has_secure_password

  validates :login, :email, :side, presence: true
  validates :side, inclusion: { 
    in: %w{ port stbd ambi },
    message: "must be 'port','stbd', or 'ambi'"
  }
  
  validates :password, length: { within: 4..40 }, if: :password_required?
  validates :login, length: { within: 3..40 }
  validates :email, length: { within: 3..100 }
  validates :login, :email, uniqueness: { case_sensitive: false }

  before_create :make_activation_code

  def human_side
    case side
    when "stbd" 
      'starboard'
    when "port" 
      'port'
    else
      'either'
    end
  end

  # Authenticates a user by their login name and unencrypted password. Returns the user or nil.
  def self.authenticate(login, password)
    user = find_by("login = ? AND activated_at IS NOT NULL", login)
    return nil unless user

    # Try modern BCrypt first
    if user.password_digest.present?
      return user if user.authenticate(password)
    end

    # Fallback to legacy SHA1
    if user.crypted_password.present? && user.salt.present?
      if user.authenticated_legacy?(password)
        # Optional: Upgrade to BCrypt on successful login
        user.password = password
        user.password_confirmation = password
        user.save(validate: false)
        return user
      end
    end

    nil
  end

  def authenticated_legacy?(password)
    return false if salt.blank? || crypted_password.blank?
    crypted_password == self.class.encrypt_legacy(password, salt)
  end

  def self.encrypt_legacy(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  def activate
    @activated = true
    update(activated_at: Time.now.utc, activation_code: nil)
  end

  def recently_activated?
    @activated
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    # Simple token for modern rails, could use more secure approach
    self.remember_token = SecureRandom.hex(20)
    save(validate: false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(validate: false)
  end

  def name
    login
  end
  
  def coxswain?
    will_cox
  end
  
  def coach?
    will_coach  
  end
  
  def public_rowing_history?
    public_rowing_history
  end
  
  def self.email_reminders
    where(send_reminders: true).find_each do |user|
      tomorrow = 1.day.from_now.to_date
      
      # Rowing events
      rowing_events = user.events.where(event_on: tomorrow)
      
      # Coaching events (based on login name in legacy)
      coaching_events = Event.where(event_on: tomorrow, coach: user.login)
      
      # Coxing events
      coxing_events = Event.where(event_on: tomorrow, coxswain: user.login)
      
      all_events = (rowing_events + coaching_events + coxing_events).uniq
      
      all_events.each do |event|
        # In Rails 8, we use deliver_now or deliver_later
        EventMailer.reminder(event).deliver_later if event.is_on?
      end
    end
  end
  
  def upcoming
    events.where("event_on >= ? AND event_on < ?", Date.today, 2.weeks.from_now.to_date)
          .order(:event_on)
          .select(&:is_on?)
  end
  
  def reset_password
    pw = random_password
    self.password = pw
    self.password_confirmation = pw
    save!
  end
  
  def rowing_history(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day # Sunday
    history = Array.new(time_period + 1, 0)
    
    historical_events = events.where("event_on <= ? AND event_on > ?", todays_date, (start_of_week - time_period.weeks))
                              .order(event_on: :desc)
    
    historical_events.each do |event|
      next unless event.is_on?
      
      0.upto(time_period) do |i|
        if event.event_on >= (start_of_week - i.weeks)
          history[i] += 1
          break
        end
      end
    end
    history
  end
  
  def completed_events(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day
    events.where("event_on <= ? AND event_on > ?", todays_date, (start_of_week - time_period.weeks))
          .order(event_on: :desc)
          .select(&:is_on?)
  end
  
  private

  def send_signup_notification
    UserMailer.signup_notification(self).deliver_later
  end

  def send_activation_notification
    UserMailer.activation_notification(self).deliver_later
  end

  def password_required?
    password_digest.blank? || password.present?
  end
  
  def make_activation_code
    self.activation_code = SecureRandom.hex(20)
  end
  
  def random_password(size = 8)
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..size).map { chars.sample }.join
  end
end
