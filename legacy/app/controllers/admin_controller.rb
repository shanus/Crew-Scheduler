class AdminController < ApplicationController

  def index
    @teams_per_page = 10
    @boats_per_page = 5
    @users_per_page = 5
    
    @teams = Team.find(:all, :limit => @teams_per_page, :order => "active DESC, name ASC")
    @boats = Boat.find(:all, :limit => @boats_per_page, :order => "name ASC")
    @users = User.find(:all, :conditions => 'activated_at IS NOT null' ,:limit => @users_per_page, :order => 'activated_at DESC')
  end
end
