module EventsHelper
  def display_date_range(event)
    html = l(event.starts_at, :format => :range_start)
    if event.starts_at.beginning_of_day == event.ends_at.beginning_of_day
      html << " - "
      html << l(event.ends_at, :format => :range_end)
    else 
      html << " to "
      html << l(event.ends_at, :format => :range_start)
    end
    html.html_safe
  end
end