class SeatingPosition < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  def self.init(event)
    unless event.nil?
      max_rowers = 1
      if (event.boat)
        max_rowers = event.boat.max_number_of_rowers
      end
      1.upto(max_rowers) { |seat|
        SeatingPosition.create( :event => event, :user => nil, :position => seat)
      }
    end
    self
  end
  
end
