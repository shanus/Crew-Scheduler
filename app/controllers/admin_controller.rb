class AdminController < ApplicationController
  # Basic admin check might be needed here later
  # before_action :admin_required

  def index
    @page_title = "Scheduler: Admin"
    @teams = Team.order(:name)
    @boats = Boat.order(:name)
    @users = User.order(:login)
  end
end
