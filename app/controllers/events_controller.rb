class EventsController < ApplicationController
  helper :boats, :teams
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @events = Event.paginate :order => "event_on DESC", :per_page => 30, :page => params[:page]
  end

  def show
    @event = Event.find(params[:id])
    @current_team = @event.team
  end

  def new
    if params[:team].nil? || params[:team].to_i == 0
      @current_team = nil
      @teams = Team.find :all
    else
      @current_team = Team.find(params[:team])
    end
    @event = Event.new
    # (TODO) change new time to be first available water 1 week from today  -slm 03/05/3008
    @event.team = @current_team
    @event.event_on = Date.today + 7.days
    @event.start_time = Time.now + 7.days
    @tides = Tide.find :all, :conditions=> [ "day >= ?", @event.event_on - 2.day ], :limit => 5
    @event.start_time = @tides[2].sunrise if (@tides[2].sunrise > @event.start_time)
    @event.end_time = @event.start_time + 1.hour
    if (@event.end_time > @tides[2].sunset)
      @event.start_time = @tides[2].sunset - 1.hour
      @event.end_time = @event.start_time + 1.hour
    end
  end

  def create
    # set start and end times correctly
    params[:event]["start_time(1i)"] = params[:event]["event_on(1i)"]  
    params[:event]["start_time(2i)"] = params[:event]["event_on(2i)"]
    params[:event]["start_time(3i)"] = params[:event]["event_on(3i)"]
    
    params[:event]["end_time(1i)"] = params[:event]["event_on(1i)"]  
    params[:event]["end_time(2i)"] = params[:event]["event_on(2i)"]
    params[:event]["end_time(3i)"] = params[:event]["event_on(3i)"]
    
    @event = Event.new(params[:event])
    # create the seating positions
    SeatingPosition.init(@event) unless @event.boat.nil?
    if @event.save
      flash[:notice] = 'Rowing time was successfully created.'
      redirect_to(team_summary_url(:id => @event.team))
    else
      @tides = Tide.find(:all, :conditions=> [ "day >= ?", @event.event_on - 2.day ], :limit => 5)
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @boat = @event.boat
    @tides = Tide.find :all, :conditions=> [ "day >= ?", @event.event_on - 2.day ], :limit => 5
  end

  def update
    @event = Event.find(params[:id])
      # set start and end times correctly
    params[:event]["start_time(1i)"] = params[:event]["event_on(1i)"]  
    params[:event]["start_time(2i)"] = params[:event]["event_on(2i)"]
    params[:event]["start_time(3i)"] = params[:event]["event_on(3i)"]
    
    params[:event]["end_time(1i)"] = params[:event]["event_on(1i)"]  
    params[:event]["end_time(2i)"] = params[:event]["event_on(2i)"]
    params[:event]["end_time(3i)"] = params[:event]["event_on(3i)"]
    
    if @event.update_attributes(params[:event])
      flash[:notice] = 'Rowing time was successfully updated.'
      redirect_to :action => 'show', :id => @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def update_rowers
    @event = Event.find(params[:id])
    @rowers = params[:rowers]
    for rower in @rowers
      id = nil
      u = User.find :first, :conditions => { :login => rower[1] }
      seat = @event.seating_positions.find(:first, :conditions => { :position => rower[0] })
      id = u.id unless u.nil?
      SeatingPosition.update(seat, :user_id => id)
    end
    if @event.update_attributes(params[:event])
      flash[:notice] = 'Rowing time was successfully updated.'
    else 
      flash[:error] = 'An error occured while saving changes.'
    end
    redirect_to(team_summary_url(:id => @event.team))
  end
end
