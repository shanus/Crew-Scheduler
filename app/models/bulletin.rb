class Bulletin < ActiveRecord::Base
  attr_accessible :content, :creator_id, :display_until, :title
  
  belongs_to :creator, :class_name => "User"
  
  validates :title, :presence => true
  validates :content, :presence => true
  validates :creator_id, :presence => true
  validates :display_until, :presence => true, :date => {:after => Proc.new { Time.now }}
end
