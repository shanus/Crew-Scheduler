class SeatingPosition < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  def self.init(event)
    1.upto(event.boat.max_number_of_rowers) { |seat|
      SeatingPosition.create( :event => event, :user => nil, :position => seat)
    }
  end
  
end
