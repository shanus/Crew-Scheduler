class DashboardController < ApplicationController
  skip_authorization_check
  
  layout :layout_by_user
  
  def index
  end
  
  private
  def layout_by_user
    if request.xhr?
    else
      if user_signed_in? && current_user.has_role?(:admin)
        "app_with_sidebar"
      else
        "application"
      end
    end
  end
end
