class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:token_authenticatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :side, :will_cox, :will_coach, :color, :time_zone, :public_rowing_history, :send_reminders
  
end
