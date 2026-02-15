class BoatUsage < ApplicationRecord
  has_many :boats
  validates :name, presence: true
end

# In Rails, we usually put one class per file, but I'll write BoatWeight too.
