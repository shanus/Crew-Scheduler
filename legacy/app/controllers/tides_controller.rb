class TidesController < ApplicationController
  
  def index
    @tides = Tide.paginate :all, :conditions=> [ "day >= ?", Date.yesterday ], :order => "day ASC", :page => params[:page]
  end
  
  def summary
    limit = params[:number]
    center_date = Date.strptime(params[:date], "%m-%d-%Y")
    @tides = Tide.find :all, :conditions=> [ "day >= ?", center_date - (limit.to_i/2).day ], :order => "day ASC", :limit => limit
    render :layout => false
  end
  
  def check_time
    date = Date.strptime(params[:date], "%d-%m-%Y")
    @tide = Tide.find :first, :conditions => { :day => date }
    @start = Time.parse("#{params[:date]} #{params[:start]}")
    @finish = Time.parse("#{params[:date]} #{params[:end]}")
    @start = Time.parse("#{@tide.sunrise.strftime("%d-%m-%Y")} #{params[:start]}") if @start.to_date != @tide.sunrise.to_date
    @finish = Time.parse("#{@tide.sunrise.strftime("%d-%m-%Y")} #{params[:end]}") if @finish.to_date != @tide.sunrise.to_date
    @messages = @tide.check_time(@start, @finish)
    @messages.concat(Event.check_start(date, params[:start]))
    #logger.info @messages
    render :layout => false
  end
  
  def upload
    @page_title = "Scheduler: Tide File Upload"
  end
  
  def preview
    # Not yet implemented, user must know what they are doing or upload junk -slm 12/06/2008 
    unless request.post?
      flash[:error] = "You must upload a tide file."
      render :action => "upload" and return
    end
    @page_title = "Scheduler: Tide File Preview"
  end
  
  def import
    unless request.post? && !params[:tide].blank?
      flash[:error] = "You must upload a tide file."
      render :action => "upload" and return
    end
    time_zone = nil
    time_zone = params[:tz][:time_zone] unless params[:tz].nil? || params[:tz][:time_zone].blank?
    filetype = params[:tide].original_filename.split(".").last
    if filetype == "csv"
      if params[:tide].class == "UploadedTempfile"
        Tide.import_tide_csv(params[:tide].local_path)
      else
        temp_file = File.new("#{RAILS_ROOT}/tmp/#{rand(10000)}-#{params[:tide].original_filename}","w")
        temp_file.write(params[:tide].read)
        temp_file.close
        Tide.import_tide_csv(temp_file.path, time_zone)
        # FileUtils.remove(temp_file.path)
      end
    elsif filetype == "txt"
      if params[:tide].class == "UploadedTempfile"
        tide_file = Tide.create_tide_csv(params[:tide].local_path)
      else
        temp_file = File.new("#{RAILS_ROOT}/tmp/#{rand(10000)}-#{params[:tide].original_filename}","w")
        temp_file.write(params[:tide].read)
        temp_file.close
        tide_file = Tide.create_tide_csv(temp_file.path)
        # FileUtils.remove(temp_file.path)
      end
      Tide.import_tide_csv(tide_file.path, time_zone)
      #FileUtils.remove(tide_file.path)
    else
      flash[:error] = "You must upload a tide file."
      render :action => "upload" and return
    end
    flash[:notice] = "Your #{filetype} tide file was succesfully imported."
    redirect_to :controller => 'admin', :action => 'index'
  end
end
