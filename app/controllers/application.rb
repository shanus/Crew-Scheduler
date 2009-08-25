# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #Initializing Authentification System for whole site
  include AuthenticatedSystem
  require_dependency 'user'
  
  helper :all

  before_filter :login_from_cookie
  before_filter :login_required, :except => [:login, :activate, :signup, :logout, :reset]
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_scheduler_session_id'
  
  protected
  # Just used for production debugging
  # def local_request?
  #     false
  #   end
  
  def rescue_action_in_public(exception)
    case exception
    when ArgumentError
      render :file => "#{RAILS_ROOT}/public/notide.html"
    else
      super
    end
  end
end
