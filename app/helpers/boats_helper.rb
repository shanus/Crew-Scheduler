module BoatsHelper
  def boat_icon(boat)
    "<img src=\"/images/#{boat.hull_type.sub(/[\+]/,'%2b')}_48.gif\" alt=\"#{boat.human_type}\" />"
  end
  
  def human_boat_type(boat)
    value = nil
    HULL_OPTIONS.each do |option|
      option.options.each do |type|
        value = "#{type.name}" if type.value == boat.hull_type
      end
    end
    value
  end
  
  def human_weight(boat)
    case boat.boat_weight.name
    when "hwt"
      return "heavyweight"
    when "mwt"
      return "midweight"
    when "lwt"
      return "lightweight"
    else
      return boat.boat_weight.name
    end
  end
end
