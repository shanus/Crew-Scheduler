class Category < ActiveRecord::Base
  attr_accessible :name
  
  has_many :hulls, :dependent => :destroy
  
  validates :name, :presence => true, :uniqueness => true
  
  def to_param
    "#{id}-#{name.to_s.strip.downcase.gsub(/[^a-z0-9\-]+/, "_")}".strip
  end
end
