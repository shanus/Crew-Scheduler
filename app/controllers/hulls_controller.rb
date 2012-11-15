class HullsController < ApplicationController
  respond_to :html, :xml, :json
  authorize_resource :class => Hull

  def index
    @hulls = Hull.all

    respond_with(@hulls)
  end

  def show
    @hull = Hull.find(params[:id])

    respond_with(@hull)
  end

  def new
    @hull = Hull.new

    respond_with(@hull)
  end

  def edit
    @hull = Hull.find(params[:id])
    
    respond_with(@hull)
  end

  def create
    @hull = Hull.new(params[:hull])

    flash[:notice] = 'Successfully created Hull.' if @hull.save
    respond_with(@hull)
  end

  def update
    @hull = Hull.find(params[:id])

    flash[:notice] = 'Successfully updated Hull.' if @hull.update_attributes(params[:hull])
    respond_with(@hull)
  end

  def destroy
    @hull = Hull.find(params[:id])
    @hull.destroy

    flash[:notice] = 'Successfully destroyed Hull.'
    respond_with(@hull)
  end

end
