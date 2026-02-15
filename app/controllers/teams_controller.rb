class TeamsController < ApplicationController
  def index
    @pagy, @teams = pagy(Team.all, limit: 10)
  end

  def list
    @pagy, @teams = pagy(Team.all, limit: 10)
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to teams_path, notice: 'Crew was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      redirect_to team_path(@team), notice: 'Crew was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to teams_path, notice: 'Crew was successfully deleted.'
  end
  
  def summary
    @current_team = Team.find(params[:id])
    @page_title = "Scheduler: #{@current_team.name} Crew"
    
    events_scope = @current_team.events.order(event_on: :desc, start_time: :desc)
    
    case params[:time]
    when 'future'
      events_scope = @current_team.events.where('event_on >= ?', Date.today).order(event_on: :asc, start_time: :asc)
    when 'past'
      events_scope = @current_team.events.where('event_on <= ?', Date.today).order(event_on: :desc, start_time: :desc)
    end
    
    @pagy, @events = pagy(events_scope, limit: 50)
    
    @ports = User.where("side != 'stbd'").order(:login)
    @starboards = User.where("side != 'port'").order(:login)
    @coaches = User.where(will_coach: true).order(:login)
    @coxswains = User.where(will_cox: true).order(:login)
  end

  private

  def team_params
    params.require(:team).permit(:name, :require_cox, :require_coach, :color, :active)
  end
end
