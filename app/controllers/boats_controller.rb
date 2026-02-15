class BoatsController < ApplicationController
  def index
    @pagy, @boats = pagy(Boat.all, limit: 20)
  end

  def list
    @pagy, @boats = pagy(Boat.all, limit: 20)
  end

  def show
    @boat = Boat.find(params[:id])
  end

  def new
    @boat = Boat.new
    @boat_usages = BoatUsage.all
    @boat_weights = BoatWeight.all
  end

  def create
    @boat = Boat.new(boat_params)
    if @boat.save
      redirect_to boats_path, notice: "Boat was successfully created."
    else
      @boat_usages = BoatUsage.all
      @boat_weights = BoatWeight.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @boat = Boat.find(params[:id])
    @boat_usages = BoatUsage.all
    @boat_weights = BoatWeight.all
  end

  def update
    @boat = Boat.find(params[:id])
    if @boat.update(boat_params)
      redirect_to boat_path(@boat), notice: "Boat was successfully updated."
    else
      @boat_usages = BoatUsage.all
      @boat_weights = BoatWeight.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @boat = Boat.find(params[:id])
    @boat.destroy
    redirect_to boats_path, notice: "Boat was successfully deleted."
  end

  def check_availability
    if params[:id].present?
      date = begin
        Date.strptime(params[:date], "%d-%m-%Y")
      rescue
        Date.today
      end
      start_time = begin
        Time.zone.parse("#{params[:date]} #{params[:start]}")
      rescue
        nil
      end
      finish_time = begin
        Time.zone.parse("#{params[:date]} #{params[:end]}")
      rescue
        nil
      end

      @boat = Boat.find(params[:id])
      @message = @boat.check_availability(date, start_time, finish_time)
    end
    render layout: false
  end

  def details
    @boat = Boat.find_by(id: params[:id]) if params[:id].present?
    render partial: "boats/boat_detail"
  end

  private

  def boat_params
    params.require(:boat).permit(:name, :hull_type, :boat_weight_id, :boat_usage_id, :color)
  end
end
