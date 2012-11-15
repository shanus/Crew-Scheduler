class Boat < ActiveRecord::Base
  attr_accessible :hull_id, :name, :usage_id, :weight_id, :color
  
  validates :name, :presence => true, :uniqueness => true
  validates :hull_id, :presence => true
  
  belongs_to :hull
  belongs_to :usage
  belongs_to :weight
  
  has_many :events, :dependent => :destroy
  
  def seats
    return 0 unless self.hull
    self.hull.max_rowers
  end
  
  def to_param
    "#{id}-#{name.to_s.strip.downcase.gsub(/[^a-z0-9\-]+/, "_")}".strip
  end
end
