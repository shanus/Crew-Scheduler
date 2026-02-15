class BulletinsController < ApplicationController
  skip_before_action :login_required, only: [:index, :show]
  
  def index
    @pagy, @bulletins = pagy(Bulletin.order(created_at: :desc), limit: 10)
    
    respond_to do |format|
      format.html
      format.xml { render xml: @bulletins }
      format.rss { render layout: false }
    end
  end

  def show
    @bulletin = Bulletin.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render xml: @bulletin }
    end
  end

  def new
    @bulletin = Bulletin.new(display_until: 7.days.from_now)
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
    if current_user != @bulletin.user
      redirect_to @bulletin, alert: "This bulletin can only be modified by #{@bulletin.user.login}."
    end
  end

  def create
    @bulletin = current_user.bulletins.build(bulletin_params)
    if @bulletin.save
      redirect_to @bulletin, notice: 'Bulletin was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @bulletin = Bulletin.find(params[:id])
    if current_user != @bulletin.user
       return redirect_to @bulletin, alert: "Unauthorized"
    end

    if @bulletin.update(bulletin_params)
      redirect_to @bulletin, notice: 'Bulletin was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bulletin = Bulletin.find(params[:id])
    if current_user != @bulletin.user
      return redirect_to bulletins_url, alert: "Unauthorized"
    end
    
    @bulletin.destroy
    redirect_to bulletins_url, notice: 'Bulletin was successfully deleted.'
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :body, :display_until)
  end
end
