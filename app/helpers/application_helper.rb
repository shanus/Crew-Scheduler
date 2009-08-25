# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_title
    @page_title ||= "Scheduler: #{controller.controller_name.capitalize} - #{controller.action_name.capitalize}"
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
    
  def rss_url(controller)
    "http://#{YOURSITE}/#{controller}.rss"
  end
  
  def random_background_image
    return stylesheet_link_tag('single') if (rand(2) == 1)
    stylesheet_link_tag('four')
  end
  
  def random_image
    image_files = %w( .jpg .gif .png )
    files = Dir.entries(
          "#{RAILS_ROOT}/public/images/rotate" 
      ).delete_if { |x| !image_files.index(x[-4,4]) }
    files[rand(files.length)]
  end
  
  def human_date(date, format = "%B %e, %Y") 
    case Date.today - date.to_date 
      when  1 then "Yesterday" 
      when  0 then "Today" 
      when -1 then "Tomorrow" 
      else date.strftime(format) 
    end 
  end
  
  def short_human_date(date, format = "%A") 
    case Date.today - date.to_date 
      when  1 then "Yesterday" 
      when  0 then "Today" 
      when -1 then "Tomorrow" 
      else date.strftime(format) 
    end 
  end
  
  def timestamps(time)
    ts = (time - TIMEOFFSET).strftime("%B %d, %Y %H:%M:%S")
    "#{ts} #{TIMEZONE}"
  end
  
  def human_time(time)
    return "#{time.hour}:00" unless time.min != 0
    "#{time.hour}:#{time.min}"
  end
  
  def add_link(class_to_add, visible_name = nil)
    @class_to_add = class_to_add
    @visible_name = class_to_add
    @visible_name = visible_name unless visible_name.nil?
  end
  
  def destroy_link(class_to_destroy, id)
    @class_to_destroy = class_to_destroy
    @destroy_id = id
  end
  
  def show_link(class_to_show, id)
    @class_to_show = class_to_show
    @show_id = id
  end
  
  def edit_link(class_to_edit, id)
    @class_to_edit = class_to_edit
    @edit_id = id
  end
  
  def list_link(class_to_list, visible_name = nil)
    @class_to_list = class_to_list
    @visible_name = class_to_list
    @visible_name = visible_name unless visible_name.nil?
  end
  
  def get_weeks(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day #set Sunday as beginning of week
    weeks = Array.new(time_period, nil)
    0.upto(time_period.to_i) { |i|
      weeks[i] = start_of_week - i.weeks
    }
    return weeks
  end
  
  def color_swatch(item)
    if item.color.blank?
      html = "none"
    else 
     html = '<span class="swatch" style="background-color: '
     html << item.color
     html << ';"> </span>'
    end
    return html
  end
  
  def small_swatch(item)
    html = '<span class="small_swatch"'
    if item.color.blank?
      html << '> </span>'
    else 
     html = ' style="background-color: '
     html << item.color
     html << ';"> </span>'
    end
    return html
  end
  
  def underline(item)
    if item.color.blank?
      html = ""
    else 
     html = ' style="border-bottom:3px solid '
     html << item.color
     html << ';"'
    end
    return html
  end
  
  def history_start(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day #set Sunday as beginning of week
    (start_of_week - time_period.to_i.weeks).strftime("%B %e, %Y")
  end
end
