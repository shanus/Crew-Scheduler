class Event < ActiveRecord::Base
  attr_accessible :boat_id, :ends_at, :starts_at, :team_id, :coach, :coxswain, :start_date, :start_time, :end_date, :end_time
  
  has_many :participations, :dependent => :destroy, :inverse_of => :event
  has_many :users, :through => :participations
  
  belongs_to :team
  belongs_to :boat
  
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true
  validates_datetime :starts_at, :on_or_after => :today
  validates_datetime :ends_at, :after => Proc.new { |e| e.starts_at }
  validates :team_id, :presence => true
  validates :boat_id, :presence => true
  
  def full?
    return false unless self.boat?
    self.users.count >= self.boat.seats
  end
  
  def team_name
    self.team ? self.team.name : "Unknown"
  end
  
  def boat_name
    self.boat ? self.boat.name : "Unknown"
  end
  
  def nick_name
    "#{self.team ? self.team.name : 'unknown'} #{self.starts_at ? self.starts_at.strftime('%Y-%m-%d') : nil}".strip
  end
  
  def start_date
    return nil if starts_at.nil?
    starts_at.to_date
  end
  
  def start_time
    return nil if starts_at.nil?
    starts_at.to_time
  end
  
  def end_date
    return nil if ends_at.nil?
    ends_at.to_date
  end
  
  def end_time
    return nil if ends_at.nil?
    ends_at.to_time
  end
   
  def to_param
    "#{id}-#{nick_name.to_s.strip.downcase.gsub(/[^a-z0-9\-]+/, "_")}".strip
  end
end
