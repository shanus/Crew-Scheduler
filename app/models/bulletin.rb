class Bulletin < ApplicationRecord
  belongs_to :user

  validates :user_id, :title, :body, :display_until, presence: true
end
