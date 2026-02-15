class AccountController < ApplicationController
  skip_before_action :login_required, only: [:login, :authenticate, :signup, :create, :activate, :reset, :send_reset]
  before_action :check_if_logged_in, only: [:login, :signup, :reset]

  # Rails 8 native rate limiting
  rate_limit to: 5, within: 10.minutes, only: [:create, :send_reset], with: -> { redirect_to root_path, alert: "Too many requests. Please try again later." }

  # Invisible Captcha protection for signup and reset
  invisible_captcha only: [:create, :send_reset], on_spam: :spam_detected

  def login
    @page_title = "Scheduler: Login"
  end

  def authenticate
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      if params[:remember_me] == "1"
        user.remember_me
        cookies.signed[:auth_token] = {
          value: user.remember_token,
          expires: user.remember_token_expires_at
        }
      end
      flash[:notice] = "Logged in successfully"
      redirect_back_or_default(root_path)
    else
      flash.now[:alert] = "Invalid login or password"
      render :login, status: :unauthorized
    end
  end

  def signup
    @page_title = "Scheduler: Sign Up"
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Thanks for signing up! Please check your email to activate your account."
      redirect_to login_path
    else
      render :signup, status: :unprocessable_entity
    end
  end

  def logout
    current_user.forget_me if logged_in?
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to login_path
  end

  def activate
    code = params[:activation_code]
    @user = User.find_by(activation_code: code)

    if @user&.activate
      flash[:notice] = "This account has been activated. Please login."
      redirect_to login_path
    else
      flash[:alert] = "Unable to activate the account. Perhaps it's already activated?"
      redirect_to root_path
    end
  end

  def reset
    @page_title = "Scheduler: Forgot Password"
  end

  def send_reset
    @user = User.find_by(email: params[:email])
    if @user
      @user.reset_password
      UserMailer.forgot_password(@user).deliver_later
      flash[:notice] = "You will receive an email shortly with your temporary password."
      redirect_to login_path
    else
      flash.now[:alert] = "No user was found for #{params[:email]}."
      render :reset, status: :not_found
    end
  end

  protected

  def spam_detected
    redirect_to root_path, alert: "Spam detected."
  end

  private

  def user_params
    params.require(:user).permit(:login, :email, :side, :password, :password_confirmation, :time_zone)
  end
end
