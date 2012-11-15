class Usage < ActiveRecord::Base
  attr_accessible :name
  
  validates :name, :presence => true, :uniqueness => true
  
  def to_param
    "#{id}-#{name.to_s.strip.downcase.gsub(/[^a-z0-9\-]+/, "_")}".strip
  end
end
