class Team < ApplicationRecord
  has_many :users
  has_many :events
  validates :name, presence: true

  scope :active, -> { where("teams.active IN (?)", [true, "true", "t", 1]) }

  def members
    users
  end

  def rowing_history(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day
    history = Array.new(time_period + 1, 0)

    historical_events = events.where("event_on <= ? AND event_on > ?", todays_date, start_of_week - time_period.weeks)
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
    events.where("event_on <= ? AND event_on > ?", todays_date, start_of_week - time_period.weeks)
      .order(event_on: :desc)
      .select(&:is_on?)
  end
end
