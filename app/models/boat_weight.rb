class BoatWeight < ApplicationRecord
  has_many :boats
  validates :name, presence: true
end
