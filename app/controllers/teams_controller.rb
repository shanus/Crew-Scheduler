class TeamsController < ApplicationController
  auto_complete_for :user, :login
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @teams = Team.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])
    if @team.save
      flash[:notice] = 'Crew was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      flash[:notice] = 'Crew was successfully updated.'
      redirect_to :action => 'show', :id => @team
    else
      render :action => 'edit'
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def summary
    @current_team = Team.find(params[:id])
    @page_title = "Scheduler: #{@current_team.name} Crew"
    case params[:time]
    when 'future'
      @events = Event.find(:all, :conditions => ['team_id = ? AND event_on >= ?', @current_team, Date.today], :order => 'event_on ASC, start_time ASC').paginate :per_page => 50, :page => params[:page]
    when 'past'
      @events = Event.find(:all, :conditions => ['team_id = ? AND event_on <= ?', @current_team, Date.today], :order => 'event_on DESC, start_time DESC').paginate :per_page => 50, :page => params[:page]
    when 'all'
      @events = Event.find(:all, :conditions => { :team_id => @current_team }, :order => 'event_on DESC, start_time DESC').paginate :per_page => 50, :page => params[:page]
    end
    # Look for ambis as well for now  -slm 03/14/2008
    @ports = User.find :all, :conditions => "side != 'stbd'", :order => 'login'
    # Look for ambis as well for now  -slm 03/14/2008
    @starboards =  User.find :all, :conditions => "side != 'port'", :order => 'login'
    @coaches =  User.find :all, :conditions => { :will_coach => true }, :order => 'login'
    @coxswains =  User.find :all, :conditions => { :will_cox => true }, :order => 'login'
  end
  
end
