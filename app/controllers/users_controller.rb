class UsersController < ApplicationController
  skip_before_action :login_required, only: [:rss]
  before_action :history_is_public, only: [:sparkline]

  def index
    @pagy, @users = pagy(User.order(:login), limit: 30)
  end

  def list
    @pagy, @users = pagy(User.order(:login), limit: 30)
  end

  def rss
    @user = User.find_by!(login: params[:login])
    @upcoming = @user.upcoming
    @title = "Upcoming Rowing for #{@user.login.capitalize}"
    @desc = "Rowing Times for the next two weeks for #{@user.login.capitalize}."
    respond_to do |format|
      format.rss { render layout: false }
    end
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def sparkline
    @user = params[:id].present? ? User.find_by(id: params[:id]) : current_user
    @user ||= current_user
    render partial: "sparkline", locals: {sparkline_data: @user.rowing_history}
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "Member was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Member was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "Member was successfully deleted."
  end

  def users_for_lookup
    @ports = User.where("side != 'stbd'").order(:login)
    @starboards = User.where("side != 'port'").order(:login)
    @coaches = User.where(will_coach: true).order(:login)
    @coxswains = User.where(will_cox: true).order(:login)
    respond_to do |format|
      format.js { render layout: false }
      format.html { render layout: false }
    end
  end

  private

  def user_params
    params.require(:user).permit(:login, :email, :side, :password, :password_confirmation, :time_zone, :will_cox, :will_coach, :send_reminders, :public_rowing_history, :color)
  end

  def history_is_public
    return true if params[:id].blank?
    user = User.find_by(id: params[:id])
    return true if user&.public_rowing_history

    render plain: " ", status: :forbidden
    false
  end
end
