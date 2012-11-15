class BoatsController < ApplicationController
  respond_to :html, :xml, :json
  authorize_resource :class => Boat

  def index
    @boats = Boat.all

    respond_with(@boats)
  end

  def show
    @boat = Boat.find(params[:id])

    respond_with(@boat)
  end

  def new
    @boat = Boat.new

    respond_with(@boat)
  end

  def edit
    @boat = Boat.find(params[:id])
    
    respond_with(@boat)
  end

  def create
    @boat = Boat.new(params[:boat])

    flash[:notice] = 'Successfully created Boat.' if @boat.save
    respond_with(@boat)
  end

  def update
    @boat = Boat.find(params[:id])

    flash[:notice] = 'Successfully updated Boat.' if @boat.update_attributes(params[:boat])
    respond_with(@boat)
  end

  def destroy
    @boat = Boat.find(params[:id])
    @boat.destroy

    flash[:notice] = 'Successfully destroyed Boat.'
    respond_with(@boat)
  end

end
