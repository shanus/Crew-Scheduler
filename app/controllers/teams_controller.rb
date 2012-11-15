class TeamsController < ApplicationController
  respond_to :html, :xml, :json
  authorize_resource :class => Team

  def index
    @teams = Team.all

    respond_with(@teams)
  end

  def show
    @team = Team.find(params[:id])

    respond_with(@team)
  end

  def new
    @team = Team.new

    respond_with(@team)
  end

  def edit
    @team = Team.find(params[:id])
    
    respond_with(@team)
  end

  def create
    @team = Team.new(params[:team])

    flash[:notice] = 'Successfully created Team.' if @team.save
    respond_with(@team)
  end

  def update
    @team = Team.find(params[:id])

    flash[:notice] = 'Successfully updated Team.' if @team.update_attributes(params[:team])
    respond_with(@team)
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    flash[:notice] = 'Successfully destroyed Team.'
    respond_with(@team)
  end

end
