class Team < ActiveRecord::Base
  attr_accessible :name, :require_cox, :require_coach, :color, :active
  
  validates :name, :presence => true, :uniqueness => true
  
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :events, :dependent => :destroy
  
  def to_param
    "#{id}-#{name.to_s.strip.downcase.gsub(/[^a-z0-9\-]+/, "_")}".strip
  end
end
