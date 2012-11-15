class UsagesController < ApplicationController
  respond_to :html, :xml, :json
  authorize_resource :class => Usage

  def index
    @usages = Usage.all

    respond_with(@usages)
  end

  def show
    @usage = Usage.find(params[:id])

    respond_with(@usage)
  end

  def new
    @usage = Usage.new

    respond_with(@usage)
  end

  def edit
    @usage = Usage.find(params[:id])
    
    respond_with(@usage)
  end

  def create
    @usage = Usage.new(params[:usage])

    flash[:notice] = 'Successfully created Usage.' if @usage.save
    respond_with(@usage)
  end

  def update
    @usage = Usage.find(params[:id])

    flash[:notice] = 'Successfully updated Usage.' if @usage.update_attributes(params[:usage])
    respond_with(@usage)
  end

  def destroy
    @usage = Usage.find(params[:id])
    @usage.destroy

    flash[:notice] = 'Successfully destroyed Usage.'
    respond_with(@usage)
  end

end
