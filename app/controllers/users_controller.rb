class UsersController < ApplicationController
  
  before_filter :login_required, :except => [:rss]
  before_filter :history_is_public, :only => [:sparkline]
  
  def index
    list
    render :action => 'list'
  end
  
  def rss
    @user = User.find_by_login(params[:login])
    return (render :status => 404, :file => "#{RAILS_ROOT}/public/404.html") if @user.nil?
    @upcoming = @user.upcoming 
    @title = "Upcoming Rowing for #{@user.login.capitalize}"
    @desc = "Rowing Times for the next two weeks for #{@user.login.capitalize}."
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
  
  def sparkline
    if params[:id].blank?
      @user = current_user
    else
      @user = User.find_by_id(params[:id])
      @user = current_user if @user.nil?
    end
    render :partial => 'sparkline', :locals => { :sparkline_data => @user.rowing_history }
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @users = User.paginate :per_page => 30, :page => params[:page], :order => 'login'
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @users = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'Member was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Member was successfully updated.'
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  # Not used anymore to keep compatible with Heroku  -slm 04/19/2008
  def users_for_lookup
    # Look for ambis as well for now  -slm 03/14/2008
    @ports = User.find :all, :conditions => "side != 'stbd'", :order => 'login'
    # Look for ambis as well for now  -slm 03/14/2008
    @starboards =  User.find :all, :conditions => "side != 'port'", :order => 'login'
    @coaches =  User.find :all, :conditions => { :will_coach => true }, :order => 'login'
    @coxswains =  User.find :all, :conditions => { :will_cox => true }, :order => 'login'
    respond_to do |format|
      format.js { }
    end
    render :layout => false
  end
  
  protected
  def history_is_public
    return true if params[:id].blank?
    user = User.find(params[:id])
    user.public_rowing_history ? true : access_denied
  end
  
  def access_denied
    render :text => " "
    false
  end
end
