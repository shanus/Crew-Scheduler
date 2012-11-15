class Participation < ActiveRecord::Base
  attr_accessible :event_id, :user_id, :position
  
  belongs_to :user
  belongs_to :event
  
  validates :user_id, :presence => true
  validates :event_id, :presence => true
  validates :position, :presence => true
  validates :position, :uniqueness => {:scope => :event_id}
  
end
