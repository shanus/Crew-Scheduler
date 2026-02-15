class TidesController < ApplicationController
  def index
    @pagy, @tides = pagy(Tide.where("day >= ?", Date.yesterday).order(:day), limit: 30)
  end

  def summary
    limit = (params[:number] || 7).to_i
    center_date = begin
      Date.strptime(params[:date], "%m-%d-%Y")
    rescue
      Date.today
    end
    @tides = Tide.where("day >= ?", center_date - (limit / 2).days).order(:day).limit(limit)
    render layout: false
  end

  def check_time
    date = begin
      Date.strptime(params[:date], "%d-%m-%Y")
    rescue
      Date.today
    end
    @tide = Tide.find_by(day: date)

    if @tide
      @start = Time.zone.parse("#{params[:date]} #{params[:start]}")
      @finish = Time.zone.parse("#{params[:date]} #{params[:end]}")

      # Ensure times match tide day (legacy normalization)
      @start = Time.zone.parse("#{@tide.day.strftime("%d-%m-%Y")} #{params[:start]}") if @start.to_date != @tide.day
      @finish = Time.zone.parse("#{@tide.day.strftime("%d-%m-%Y")} #{params[:end]}") if @finish.to_date != @tide.day

      @messages = @tide.check_time(@start, @finish)
      @messages.concat(Event.check_start(date, params[:start]))
    else
      @messages = ["No tide information found for this date."]
    end

    render layout: false
  end

  def upload
    @page_title = "Scheduler: Tide File Upload"
  end

  def import
    unless request.post? && params[:tide].present?
      flash[:error] = "You must upload a tide file."
      return redirect_to action: :upload
    end

    time_zone = params.dig(:tz, :time_zone).presence || "UTC"
    uploaded_file = params[:tide]
    file_path = uploaded_file.path
    filetype = File.extname(uploaded_file.original_filename).delete(".")

    begin
      case filetype
      when "csv"
        Tide.import_tide_csv(file_path, time_zone)
      when "txt"
        csv_path = Tide.create_tide_csv(file_path)
        Tide.import_tide_csv(csv_path, time_zone)
      else
        flash[:error] = "Unsupported file type. Please upload a .csv or .txt file."
        return redirect_to action: :upload
      end
      flash[:notice] = "Your #{filetype} tide file was successfully imported."
    rescue => e
      flash[:error] = "An error occurred during import: #{e.message}"
    end

    redirect_to admin_path
  end
end
