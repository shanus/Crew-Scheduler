class BulletinsController < ApplicationController
  respond_to :html, :xml, :json
  authorize_resource :class => Bulletin

  def index
    @bulletins = Bulletin.all

    respond_with(@bulletins)
  end

  def show
    @bulletin = Bulletin.find(params[:id])

    respond_with(@bulletin)
  end

  def new
    @bulletin = Bulletin.new

    respond_with(@bulletin)
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
    
    respond_with(@bulletin)
  end

  def create
    @bulletin = Bulletin.new(params[:bulletin])

    flash[:notice] = 'Successfully created Bulletin.' if @bulletin.save
    respond_with(@bulletin)
  end

  def update
    @bulletin = Bulletin.find(params[:id])

    flash[:notice] = 'Successfully updated Bulletin.' if @bulletin.update_attributes(params[:bulletin])
    respond_with(@bulletin)
  end

  def destroy
    @bulletin = Bulletin.find(params[:id])
    @bulletin.destroy

    flash[:notice] = 'Successfully destroyed Bulletin.'
    respond_with(@bulletin)
  end

end
