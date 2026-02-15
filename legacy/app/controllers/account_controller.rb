class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :check_if_logged_in, :only => [:reset, :login, :signup]
  
  # say something nice, you goof!  something sweet.
  def index
    redirect_to(signup_url) unless logged_in? || User.count > 0
    @user = current_user
  end

  def login
    @page_title = "Scheduler: Login"
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(summary_url)
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @page_title = "Scheduler: Sign Up"
    @user = User.new(params[:user])
    return unless request.post?
    if verify_recaptcha(@post)
      @user.save!
      #self.current_user = @user
      redirect_back_or_default(login_url)
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error] = "There was an error with your recaptcha entry."
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    # commented out because heroku does not like this  -slm 06/24/2008
    #cookies.delete :auth_token
    reset_session
    redirect_to(login_url)
    flash[:notice] = "You have been logged out."
  end
  
  def activate
    flash.clear
    @code = params[:activation_code]
    return if (params[:id] == nil) && (params[:activation_code] == nil)
    activator = params[:id] || params[:activation_code]
    @user = User.find_by_activation_code(activator)
    if @user and @user.activate
      #self.current_user = @user
      redirect_back_or_default(login_url)
      flash[:notice] = "This account has been activated. Please login."
    else  
      redirect_back_or_default(summary_url)
      flash[:error] = "Unable to activate the account.  Perhaps the account is already activated?"
    end
  end
  
  def reset
    @page_title = "Scheduler: Forgot Password"
    return unless request.post?
    if verify_recaptcha(@post)
      @user = User.find :first, :conditions => { :email => params[:email] }
      if @user.nil?
        redirect_to(:action => "reset")
        flash[:error] = "No user was found for #{params[:email]}."
      else
        @user.reset_password
        UserNotifier.deliver_forgot_password(@user)
        redirect_to(login_url)
        flash[:notice] = "You will receive an email shortly with your temporary password."
      end
    else
      flash[:error] = "There was an error with your recaptcha entry."
    end
  end
end
