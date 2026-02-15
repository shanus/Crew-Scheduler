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
end
