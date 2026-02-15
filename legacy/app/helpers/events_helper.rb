module EventsHelper
  def event_status(event)
    status = "nogo"
    if event.is_on? 
      status = "go"
    end
    image_tag "#{status}.jpg"
  end
  
  def allow_input(event)
    allow = "disabled"
    allow = "enabled" unless event.within_time_limit?
    "#{allow}"
  end
end
