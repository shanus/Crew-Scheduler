class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:token_authenticatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :side, :will_cox, :will_coach, :color, :time_zone, :public_rowing_history, :send_reminders
  
  has_many :memberships, :dependent => :destroy, :inverse_of => :user
  has_many :teams, :through => :memberships
  has_many :participations, :dependent => :destroy, :inverse_of => :user
  has_many :events, :through => :participations
  has_many :tips, :dependent => :destroy
  has_many :bulletins, :dependent => :destroy
  
  def full_name
    "#{self.first_name} #{self.last_name}".strip
  end
  
  def reverse_full_name
    name = "#{self.last_name}, #{self.first_name}".strip
    name = nil if name.length <= 1
    
    name
  end
  
  def visible_name(short_version = true)
    if short_version
      self.first_name.blank? ? self.email : self.first_name
    else
      self.full_name.blank? ? self.email : self.full_name
    end
  end
  
  def name
    visible_name(false)
  end
  
  def to_param
    "#{id}-#{name.to_s.strip.downcase.gsub(/[^a-z0-9\-]+/, "_")}".strip
  end
end
