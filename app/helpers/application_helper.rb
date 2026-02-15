module ApplicationHelper
  include Pagy::Method
  def markdown(text)
    return "" if text.blank?
    Kramdown::Document.new(text).to_html.html_safe
  end

  def sparkline(data)
    # Modern CSS-based sparkline (mini bar chart)
    return "" if data.empty?
    max = data.max.to_f
    max = 1.0 if max == 0

    content_tag(:div, class: "d-flex align-items-end overflow-hidden", style: "height: 20px; gap: 1px;") do
      data.map do |val|
        height = (val / max * 100).to_i
        content_tag(:div, "", class: "bg-primary flex-grow-1", style: "height: #{height}%; min-width: 2px;", title: "#{val} sessions")
      end.join.html_safe
    end
  end

  def page_title
    @page_title ||= "Scheduler: #{controller.controller_name.humanize} - #{controller.action_name.humanize}"
  end

  def rss_url(controller_name)
    "https://#{CrewScheduler::YOURSITE}/#{controller_name}.rss"
  end

  def random_background_image
    # Modernizing the random background logic
    return stylesheet_link_tag("single", "data-turbo-track": "reload") if rand(2) == 1
    stylesheet_link_tag("four", "data-turbo-track": "reload")
  end

  def human_date(date, format: "%B %e, %Y")
    return "" if date.nil?
    d = date.to_date
    today = Date.today

    if d == today
      "Today"
    elsif d == today - 1
      "Yesterday"
    elsif d == today + 1
      "Tomorrow"
    else
      d.strftime(format)
    end
  end

  def short_human_date(date)
    human_date(date, format: "%A")
  end

  def human_time(time)
    return "" if time.nil?
    time.strftime(time.min == 0 ? "%H:00" : "%H:%M")
  end

  def color_swatch(item)
    return "none" if item.color.blank?
    content_tag(:span, " ", class: "swatch", style: "background-color: #{item.color};")
  end

  def small_swatch(item)
    content_tag(:span, " ", class: "small_swatch", style: item.color.present? ? "background-color: #{item.color};" : "")
  end

  def underline_style(item)
    item.color.present? ? "border-bottom: 3px solid #{item.color};" : ""
  end

  def get_weeks(time_period = 24)
    start_of_week = Date.today.beginning_of_week - 1.day # Sunday
    (0..time_period).map { |i| start_of_week - i.weeks }
  end
end
