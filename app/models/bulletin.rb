class Bulletin < ActiveRecord::Base
  attr_accessible :content, :creator_id, :display_until, :title
end
