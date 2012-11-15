class Hull < ActiveRecord::Base
  attr_accessible :category_id, :name, :seats
  
  has_many :boats
  belongs_to :category
  
  validates :name, :presence => true
  validates :seats, :presence => true, :uniqueness => true
  
  def needs_coxswain?
    self.seats.to_s.ends_with?("+")
  end
  
  def visible_name
    "#{self.name} (#{self.seats})"
  end
  
  def max_rowers
    self.seats.to_i
  end
  
  def to_param
    "#{id}-#{name.to_s.strip.downcase.gsub(/[^a-z0-9\-]+/, "_")}".strip
  end
end
