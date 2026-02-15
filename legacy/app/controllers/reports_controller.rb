class ReportsController < ApplicationController

  def index
    @page_title = "Scheduler: Reports"
  end
  
  def rower_history
    @rower_history_data_link = formatted_rower_history_reports_url(:xml)
    respond_to do |format|
      format.html { 
        @rowers = User.find :all, :conditions => { :public_rowing_history => true }, :order => "login ASC"
        @not_available = User.find :all, :conditions => { :public_rowing_history => false }, :order => "login ASC"
        render :layout => false if (request.xhr?) 
      }
      format.xml  { 
        @user = User.find(params[:id])
        render :action => "rower_history.xml.builder", :layout => false 
      }
    end
  end
  
  def crew_history
    @crew_history_data_link = formatted_crew_history_reports_url(:xml)
    respond_to do |format|
      format.html { 
        @crews = Team.find :all, :order => "active DESC,name ASC"
        render :layout => false if (request.xhr?) 
      }
      format.xml  {
        @crew = Team.find(params[:id])
        render :action => "crew_history.xml.builder", :layout => false 
      }
    end
  end
  
  def boat_utilization
    @boat_utilization_data_link = formatted_boat_utilization_reports_url(:xml)
    respond_to do |format|
      format.html { 
        @boats = Boat.find :all, :order => "name ASC"
        render :layout => false if (request.xhr?) 
      }
      format.xml  { 
        @boat = Boat.find(params[:id])
        render :action => "boat_utilization.xml.builder", :layout => false 
      }
    end
  end
  
  def boat_usage_by_crew
    @boat_usage_by_crew_data_link = formatted_boat_usage_by_crew_reports_url(:xml)
    @crew_breakdown = Hash.new
    @events_breakdown = Hash.new
    respond_to do |format|
      format.html { 
        @boats = Boat.find :all, :order => "name ASC"
        for boat in @boats
          @events = boat.completed_events
          @crew_breakdown["#{boat.name}"] = Hash.new
          @events_breakdown["#{boat.name}"] = @events.size
          @events.each do |e|
            @crew_breakdown["#{boat.name}"]["#{e.team.name}"].nil? ? @crew_breakdown["#{boat.name}"]["#{e.team.name}"] = 1 : @crew_breakdown["#{boat.name}"]["#{e.team.name}"] += 1
          end
        end
        render :layout => false if (request.xhr?) 
      }
      format.xml  { 
        @boat = Boat.find(params[:id])
        @events = @boat.completed_events
        @crew_breakdown["#{@boat.name}"] = Hash.new
        @events_breakdown["#{@boat.name}"] = @events.size
        @events.each do |e|
          @crew_breakdown["#{@boat.name}"]["#{e.team.name}"].nil? ? @crew_breakdown["#{@boat.name}"]["#{e.team.name}"] = 1 : @crew_breakdown["#{@boat.name}"]["#{e.team.name}"] += 1
        end
        render :action => "boat_usage_by_crew.xml.builder", :layout => false 
      }
    end
  end
  
  def crew_usage_of_boats
    @crew_usage_of_boats_data_link = formatted_crew_usage_of_boats_reports_url(:xml)
    @boat_breakdown = Hash.new
    @events_breakdown = Hash.new
    respond_to do |format|
      format.html { 
        @crews = Team.find :all, :order => "name ASC"
        for crew in @crews
          @events = crew.completed_events
          @boat_breakdown["#{crew.name}"] = Hash.new
          @events_breakdown["#{crew.name}"] = @events.size
          @events.each do |e|
            @boat_breakdown["#{crew.name}"]["#{e.boat.name}"].nil? ? @boat_breakdown["#{crew.name}"]["#{e.boat.name}"] = 1 : @boat_breakdown["#{crew.name}"]["#{e.boat.name}"] += 1
          end
        end
        render :layout => false if (request.xhr?) 
      }
      format.xml  { 
        @crew = Team.find(params[:id])
        @events = @crew.completed_events
        @boat_breakdown["#{@crew.name}"] = Hash.new
        @events_breakdown["#{@crew.name}"] = @events.size
        @events.each do |e|
          @boat_breakdown["#{@crew.name}"]["#{e.boat.name}"].nil? ? @boat_breakdown["#{@crew.name}"]["#{e.boat.name}"] = 1 : @boat_breakdown["#{@crew.name}"]["#{e.boat.name}"] += 1
        end
        render :action => "crew_usage_of_boats.xml.builder", :layout => false 
      }
    end
  end
  
  def my_rowing_breakdown
    @user = current_user
    @events = @user.completed_events
    @boating_breakdown = Hash.new
    @crew_breakdown = Hash.new
    @seating_breakdown = Hash.new
    @events.each do |e|
      @boating_breakdown["#{e.boat.name}"].nil? ? @boating_breakdown["#{e.boat.name}"] = 1 : @boating_breakdown["#{e.boat.name}"] += 1
      @crew_breakdown["#{e.team.name}"].nil? ? @crew_breakdown["#{e.team.name}"] = 1 : @crew_breakdown["#{e.team.name}"] += 1
      seat = e.find_rower_seat(@user)
      unless seat.nil?
        @seating_breakdown["#{seat}"].nil? ? @seating_breakdown["#{seat}"] = 1 : @seating_breakdown["#{seat}"] +=1
      end
    end
    
    @my_rowing_breakdown_data_link = formatted_my_rowing_breakdown_reports_url(:xml)
    
    respond_to do |format|
      format.html { render :layout => false if (request.xhr?) }
      format.xml  { render :action => "my_rowing_breakdown.xml.builder", :layout => false }
    end
  end
end
