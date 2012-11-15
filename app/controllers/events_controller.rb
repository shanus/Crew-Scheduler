class EventsController < ApplicationController
  respond_to :html, :xml, :json
  authorize_resource :class => Event

  def index
    @events = Event.all

    respond_with(@events)
  end

  def show
    @event = Event.find(params[:id])

    respond_with(@event)
  end

  def new
    @event = Event.new

    respond_with(@event)
  end

  def edit
    @event = Event.find(params[:id])
    
    respond_with(@event)
  end

  def create
    @event = Event.new(params[:event])

    flash[:notice] = 'Successfully created Event.' if @event.save
    respond_with(@event)
  end

  def update
    @event = Event.find(params[:id])

    flash[:notice] = 'Successfully updated Event.' if @event.update_attributes(params[:event])
    respond_with(@event)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    flash[:notice] = 'Successfully destroyed Event.'
    respond_with(@event)
  end

end
