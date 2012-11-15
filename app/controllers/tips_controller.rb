class TipsController < ApplicationController
  respond_to :html, :xml, :json
  authorize_resource :class => Tip

  def index
    @tips = Tip.all

    respond_with(@tips)
  end

  def show
    @tip = Tip.find(params[:id])

    respond_with(@tip)
  end

  def new
    @tip = Tip.new

    respond_with(@tip)
  end

  def edit
    @tip = Tip.find(params[:id])
    
    respond_with(@tip)
  end

  def create
    @tip = Tip.new(params[:tip])
    @tip.creator = current_user
    @tip.modifier = current_user

    flash[:notice] = 'Successfully created Help.' if @tip.save
    respond_with(@tip)
  end

  def update
    @tip = Tip.find(params[:id])
    @tip.modifier = current_user

    flash[:notice] = 'Successfully updated Help.' if @tip.update_attributes(params[:tip])
    respond_with(@tip)
  end

  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy

    flash[:notice] = 'Successfully destroyed Help Item.'
    respond_with(@tip)
  end

end
