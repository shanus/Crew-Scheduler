class Event < ApplicationRecord
  has_many :seating_positions, dependent: :destroy
  has_many :users, through: :seating_positions
  belongs_to :team
  belongs_to :boat

  alias_attribute :date, :event_on

  after_save :send_rowing_notification, if: -> { is_on? && event_on > Date.today }

  def send_rowing_notification
    EventMailer.rowing_notification(self).deliver_later
  end

  validates :boat_id, presence: true

  def is_on?
    return false unless boat
    max_rowers = boat.max_number_of_rowers
    rowers_filled = users.count >= max_rowers
    # coxswain required then coxswain must be filled
    coxswain_filled = !needs_coxswain?
    # coach required then must have coach filled in
    coach_filled = !needs_coach?

    rowers_filled && coxswain_filled && coach_filled
  end

  def needs_coxswain?
    return true if team.nil?
    team.require_cox && (coxswain.nil? || coxswain.blank?)
  end

  def needs_coach?
    return true if team.nil?
    team.require_coach && (coach.nil? || coach.blank?)
  end

  def within_time_limit?
    # Logic: event starts within 20 hours from now
    event_time = begin
      Time.zone.parse("#{event_on} #{start_time.strftime("%H:%M")}")
    rescue
      nil
    end
    return false unless event_time
    event_time <= (Time.now + 20.hours)
  end

  def self.today
    where(event_on: Date.today).order(:start_time).select(&:is_on?)
  end

  def self.tomorrow
    where(event_on: Date.tomorrow).order(:start_time).select(&:is_on?)
  end

  def self.day_after_tomorrow
    where(event_on: 2.days.from_now.to_date).order(:start_time).select(&:is_on?)
  end

  def self.needed
    where("event_on >= ?", Date.today)
      .where("event_on < ?", 4.days.from_now.to_date)
      .order(:event_on)
      .reject(&:is_on?)
      .reject(&:within_time_limit?)
  end

  def self.daily_notify
    tomorrow_events = tomorrow
    tomorrow_events.each do |event|
      recipients = []
      rowers = event.users
      coach = User.find_by(login: event.coach)
      coxswain = User.find_by(login: event.coxswain)

      recipients << coach if coach&.send_reminders
      recipients << coxswain if coxswain&.send_reminders
      rowers.each { |r| recipients << r if r.send_reminders }

      recipients = recipients.uniq
      if recipients.any?
        EventMailer.reminder(event, recipients).deliver_later
      end
    end
  end

  def self.check_start(date, start_time_str)
    # start_time_str is like "06:00"
    # Modern active record doesn't need adapter checks for simple LIKE if handled correctly,
    # but let's use a more robust way:
    events = where(event_on: date).where("strftime('%H:%M', start_time) = ?", start_time_str)
    # Note: sqlite specific strftime. For production (PG), it would be different.
    # A better way is to store start_time as a proper time type or use a range.

    return [nil] unless events.size > 1
    ["#{events.size} crews are launching at the same time"]
  end

  def team_name
    team&.name || "Unknown"
  end

  def boat_name
    boat&.name || "Unknown"
  end

  def rowers
    rowers_hash = {}
    seating_positions.includes(:user).each do |seat|
      rowers_hash[seat.position] = seat.user&.login
    end
    rowers_hash
  end

  def start_hour_min
    start_time.strftime("%H:%M")
  end

  def end_hour_min
    end_time.strftime("%H:%M")
  end

  def coach_email
    User.find_by(login: coach)&.email unless coach.blank?
  end

  def coxswain_email
    return nil unless boat&.has_coxswain?
    User.find_by(login: coxswain)&.email unless coxswain.blank?
  end

  def rowers_email
    users.pluck(:email)
  end

  def coxswain_name
    coxswain.blank? ? "none" : coxswain
  end

  def coach_name
    coach.blank? ? "none" : coach
  end

  def find_rower_seat(rower_id)
    seating_positions.find_by(user_id: rower_id)&.position
  end
end
