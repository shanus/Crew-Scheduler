class BoatsController < ApplicationController
  require_dependency "hull_type"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @boats = Boat.paginate :per_page => 20, :page => params[:page]
  end

  def show
    @boat = Boat.find(params[:id])
  end

  def new
    @boat = Boat.new
    @BoatUsages = BoatUsage.find :all
    @BoatWeights = BoatWeight.find :all
  end

  def create
    @boat = Boat.new(params[:boat])
    if @boat.save
      flash[:notice] = 'Boat was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @boat = Boat.find(params[:id])
    @BoatUsages = BoatUsage.find :all
    @BoatWeights = BoatWeight.find :all
  end

  def update
    @boat = Boat.find(params[:id])
    if @boat.update_attributes(params[:boat])
      flash[:notice] = 'Boat was successfully updated.'
      redirect_to :action => 'show', :id => @boat
    else
      render :action => 'edit'
    end
  end

  def destroy
    Boat.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def check_availability
    if !(params[:id].nil? || params[:id] == "")
      date = Date.strptime(params[:date], "%d-%m-%Y")
      start = Time.parse("#{params[:date]} #{params[:start]}")
      finish = Time.parse("#{params[:date]} #{params[:end]}")
      @boat = Boat.find(params[:id])
      @message = @boat.check_availability(date, start, finish)
    end
    render :layout => false
  end
  
  def details
    @boat = Boat.find(params[:id]) unless (params[:id].nil? || params[:id] == "")
    render :partial => 'boats/boat_detail'
  end
  
end
