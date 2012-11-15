class WeightsController < ApplicationController
  respond_to :html, :xml, :json
  authorize_resource :class => Weight

  def index
    @weights = Weight.all

    respond_with(@weights)
  end

  def show
    @weight = Weight.find(params[:id])

    respond_with(@weight)
  end

  def new
    @weight = Weight.new

    respond_with(@weight)
  end

  def edit
    @weight = Weight.find(params[:id])
    
    respond_with(@weight)
  end

  def create
    @weight = Weight.new(params[:weight])

    flash[:notice] = 'Successfully created Weight.' if @weight.save
    respond_with(@weight)
  end

  def update
    @weight = Weight.find(params[:id])

    flash[:notice] = 'Successfully updated Weight.' if @weight.update_attributes(params[:weight])
    respond_with(@weight)
  end

  def destroy
    @weight = Weight.find(params[:id])
    @weight.destroy

    flash[:notice] = 'Successfully destroyed Weight.'
    respond_with(@weight)
  end

end
