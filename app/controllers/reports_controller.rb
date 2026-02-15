class ReportsController < ApplicationController
  def index
    @page_title = "Scheduler: Reports"
  end
  
  def rower_history
    @rowers = User.where(public_rowing_history: true).order(:login)
    @not_available = User.where(public_rowing_history: false).order(:login)
    
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.xml do
        @user = User.find(params[:id])
        # render builder path might need update later if views aren't ported yet
      end
    end
  end
  
  def crew_history
    @crews = Team.order(active: :desc, name: :asc)
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.xml { @crew = Team.find(params[:id]) }
    end
  end
  
  def boat_utilization
    @boats = Boat.order(:name)
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.xml { @boat = Boat.find(params[:id]) }
    end
  end
  
  def boat_usage_by_crew
    @boats = Boat.order(:name)
    @crew_breakdown = {}
    @events_breakdown = {}
    
    @boats.each do |boat|
      completed_events = boat.completed_events
      @events_breakdown[boat.name] = completed_events.size
      @crew_breakdown[boat.name] = {}
      
      completed_events.each do |e|
        team_name = e.team&.name || "Unknown"
        @crew_breakdown[boat.name][team_name] ||= 0
        @crew_breakdown[boat.name][team_name] += 1
      end
    end

    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.xml { @boat = Boat.find(params[:id]) } # Additional logic might be needed for XML
    end
  end
  
  def crew_usage_of_boats
    @crews = Team.order(:name)
    @boat_breakdown = {}
    @events_breakdown = {}

    @crews.each do |crew|
      completed_events = crew.completed_events
      @events_breakdown[crew.name] = completed_events.size
      @boat_breakdown[crew.name] = {}
      
      completed_events.each do |e|
        boat_name = e.boat&.name || "Unknown"
        @boat_breakdown[crew.name][boat_name] ||= 0
        @boat_breakdown[crew.name][boat_name] += 1
      end
    end

    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.xml { @crew = Team.find(params[:id]) }
    end
  end
  
  def my_rowing_breakdown
    @user = current_user
    @events = @user.completed_events
    @boating_breakdown = {}
    @crew_breakdown = {}
    @seating_breakdown = {}

    @events.each do |e|
      boat_name = e.boat&.name || "Unknown"
      team_name = e.team&.name || "Unknown"
      
      @boating_breakdown[boat_name] ||= 0
      @boating_breakdown[boat_name] += 1
      
      @crew_breakdown[team_name] ||= 0
      @crew_breakdown[team_name] += 1
      
      seat = e.find_rower_seat(@user.id)
      if seat
        @seating_breakdown[seat.to_s] ||= 0
        @seating_breakdown[seat.to_s] += 1
      end
    end
    
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.xml # Renders my_rowing_breakdown.xml.builder
    end
  end
end
