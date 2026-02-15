class SeatingPosition < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  def self.init(event)
    return self if event.nil?

    max_rowers = event.boat&.max_number_of_rowers || 1
    1.upto(max_rowers) do |seat|
      SeatingPosition.create(event: event, user: nil, position: seat)
    end
    self
  end

  def position_name
    return "Seat" if event.nil? || event.boat.nil?

    max_rowers = event.boat.max_number_of_rowers
    if max_rowers == 1
      "Single"
    elsif position == max_rowers
      "Stroke"
    elsif position == 1
      "Bow"
    else
      "Seat #{position}"
    end
  end
end
