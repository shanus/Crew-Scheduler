class Bulletin < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of     :user_id, :title, :body, :display_until
end
