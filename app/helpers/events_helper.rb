module EventsHelper
  def event_status(event)
    # Modernized event status badges
    if event.date < Date.today
      content_tag(:span, "Past", class: "badge bg-secondary")
    elsif event.date == Date.today
      content_tag(:span, "Today", class: "badge bg-warning text-dark border")
    else
       content_tag(:span, "Upcoming", class: "badge bg-success")
    end
  end

  def human_time(time)
    # Modern time formatting using standard Rails strftime
    return "--" if time.nil?
    time.strftime("%l:%M %p").strip
  end

  def users_autocomplete_data
    # This replaces the legacy users_javascript hack
    # Returning a JSON-safe array for modern autocomplete (e.g. Stimulus + TomSelect/Choices.js)
    User.active.order(:login).map { |u| { value: u.id, label: u.login } }.to_json
  end
  
  def boat_options_for_select(selected_boat_id = nil)
    # Helper to group boats by usage or hull type if needed for the form
    Boat.order(:name).map { |b| [b.name, b.id] }
  end
end
