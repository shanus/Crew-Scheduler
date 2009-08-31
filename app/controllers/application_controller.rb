# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #Initializing Authentification System for whole site
  include AuthenticatedSystem
  require_dependency 'user'
  
  helper :all
  before_filter :set_user_time_zone
  before_filter :login_from_cookie
  before_filter :login_required, :except => [:login, :activate, :signup, :logout, :reset]
  before_filter :ensure_domain
  

  
  protected
  # Just used for production debugging
  # def local_request?
  #     false
  #   end
  
  def set_user_time_zone
    if logged_in? && !current_user.time_zone.nil?
      Time.zone = current_user.time_zone
    else
      Time.zone = 'Eastern Time (US & Canada)'
    end
  end
  
  def ensure_domain
    if request.env['HTTP_HOST'] != 'scheduler.yarmouth-rowing.org' && RAILS_ENV == "production"
      redirect_to 'http://scheduler.yarmouth-rowing.org'
    end
  end
  
  def rescue_action_in_public(exception)
    case exception
    when ArgumentError
      render :file => "#{RAILS_ROOT}/public/notide.html"
    else
      super
    end
  end
end
