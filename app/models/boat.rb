class Boat < ApplicationRecord
  has_many :events, dependent: :destroy
  belongs_to :boat_usage
  belongs_to :boat_weight

  validates :name, :hull_type, :boat_usage, :boat_weight, presence: true
  validates :hull_type, format: {
    with: /\A[1,248][Xx\-+]\z/,
    message: "is not a valid type"
  }
  validates :name, uniqueness: true

  def has_coxswain?
    hull_type.include?("+")
  end

  def max_number_of_rowers
    hull_type[0, 1].to_i
  end

  def human_type
    # Assuming HullType is ported or logic is inline
    HULL_OPTIONS.each do |hull_group|
      hull_group.options.each do |option|
        return option.name if option.value == hull_type
      end
    end
    nil
  end

  def check_availability(date, start, finish)
    conflicting_events = events.where(event_on: date)
    return nil if conflicting_events.empty?

    conflicting_events.each do |e|
      # Skip overlapping logic if times don't conflict
      next if finish <= e.start_time || start >= e.end_time

      message = if e.is_on?
        "#{e.team.name} crew is using the #{name} from #{e.start_time.strftime("%H:%M")} to #{e.end_time.strftime("%H:%M")} (boat full)"
      else
        "#{e.team.name} crew is possibly using the #{name} from #{e.start_time.strftime("%H:%M")} to #{e.end_time.strftime("%H:%M")} (boat not full)"
      end
      return message
    end
    nil
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
