class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Method

  before_action :login_from_cookie
  before_action :set_user_time_zone
  before_action :login_required
  before_action :load_active_teams

  protected

  def load_active_teams
    @active_teams = Team.where(active: true).order(id: :desc) if logged_in?
  end

  def set_user_time_zone
    if logged_in? && current_user.time_zone.present?
      Time.use_zone(current_user.time_zone) { yield if block_given? } # Standard modern way is via around_action
      # But legacy just set Time.zone. In Rails 8, it's safer to use Time.use_zone.
      Time.zone = current_user.time_zone
    else
      Time.zone = 'Eastern Time (US & Canada)'
    end
  end

end
