module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?
  end

  protected

  def current_user
    @current_user ||= authenticate_user_from_session || false
  end

  def logged_in?
    current_user != false
  end

  def current_user=(user)
    session[:user_id] = user&.id
    @current_user = user || false
  end

  def login_required
    logged_in? || access_denied
  end

  def check_if_logged_in
    access_summary if logged_in?
  end

  def access_summary
    flash[:notice] = "You are already logged in."
    redirect_to root_path
  end

  def access_denied
    store_location
    flash[:alert] = "Please log in to continue."
    redirect_to login_path
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def login_from_session
    self.current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_from_cookie
    return if logged_in? || cookies.signed[:auth_token].blank?

    user = User.find_by(remember_token: cookies.signed[:auth_token])
    if user&.remember_token?
      user.remember_me
      self.current_user = user
      cookies.signed[:auth_token] = {
        value: user.remember_token,
        expires: user.remember_token_expires_at
      }
    end
  end

  private

  def authenticate_user_from_session
    User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
