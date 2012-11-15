class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization :unless => :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  before_filter :set_time_zone
  before_filter :load_help
  
  protected
  def set_time_zone
    if user_signed_in?
      Time.zone = current_user.time_zone || 'UTC'
    else
      Time.zone = 'UTC'
    end
    logger.debug "time zone set to #{Time.zone}" if Rails.env.development?
  end
  
  def load_help
    return if request.format.nil?
    return unless request.format.html?
   # @current_help = Tip.find_by_path "#{controller_name} - #{action_name}"
  end
end
