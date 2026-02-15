class EventsController < ApplicationController
  def index
    @pagy, @events = pagy(Event.order(event_on: :desc), limit: 30)
  end

  def list
    @pagy, @events = pagy(Event.order(event_on: :desc), limit: 30)
  end

  def show
    @event = Event.find(params[:id])
    @current_team = @event.team
  end

  def new
    if params[:team].blank? || params[:team].to_i == 0
      @current_team = nil
      @teams = Team.all
    else
      @current_team = Team.find(params[:team])
    end

    @event = Event.new(team: @current_team)
    @event.event_on = Date.today + 7.days

    # Try to find tides for the date to suggest a good start time
    @tides = Tide.where("day >= ?", @event.event_on - 2.days).limit(5)
    if @tides[2]
      suggested_start = [@tides[2].sunrise, Time.zone.now + 7.days].max
      @event.start_time = suggested_start
      @event.end_time = @event.start_time + 1.hour
      if @event.end_time > @tides[2].sunset
        @event.start_time = @tides[2].sunset - 1.hour
        @event.end_time = @event.start_time + 1.hour
      end
    else
      @event.start_time = Time.zone.now + 7.days
      @event.end_time = @event.start_time + 1.hour
    end
  end

  def create
    normalize_times
    @event = Event.new(event_params)

    if @event.save
      SeatingPosition.init(@event) if @event.boat.present?
      flash[:notice] = "Rowing time was successfully created."
      redirect_to summary_team_path(@event.team)
    else
      @tides = Tide.where("day >= ?", @event.event_on - 2.days).limit(5)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
    @boat = @event.boat
    @tides = Tide.where("day >= ?", @event.event_on - 2.days).limit(5)
  end

  def update
    normalize_times
    @event = Event.find(params[:id])

    if @event.update(event_params)
      flash[:notice] = "Rowing time was successfully updated."
      redirect_to boat_path(@event.boat) # Matches legacy show action logic or redirect as needed
    else
      @tides = Tide.where("day >= ?", @event.event_on - 2.days).limit(5)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: "Event was successfully deleted."
  end

  def update_rowers
    @event = Event.find(params[:id])
    rowers_params = params[:rowers] || {}

    rowers_params.each do |position, login|
      user = User.find_by(login: login)
      seat = @event.seating_positions.find_by(position: position)
      seat&.update(user_id: user&.id)
    end

    if @event.update(event_params)
      flash[:notice] = "Rowing time was successfully updated."
    else
      flash[:error] = "An error occurred while saving changes."
    end
    redirect_to summary_team_path(@event.team)
  end

  private

  def event_params
    params.require(:event).permit(:event_on, :start_time, :end_time, :team_id, :boat_id, :coxswain, :coach)
  end

  def normalize_times
    # In modern Rails with multi-parameter attributes, usually Rails handles this,
    # but the legacy code manually synced date with time.
    # If the form uses date_select/time_select, Rails 8 handles the parts.
    # Keeping the spirit of the legacy normalization if needed.
  end
end
