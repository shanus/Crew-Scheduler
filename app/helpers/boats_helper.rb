module BoatsHelper
  def boat_icon(boat)
    # Modernized to look for icon in assets or use a placeholder
    # Legacy path was /images/#{hull_type}_48.gif
    icon_name = boat.hull_type.to_s.gsub('+', 'plus')
    image_tag "boats/#{icon_name}_48.gif", alt: boat.name, class: "boat-icon" rescue nil
  end
  
  def human_boat_type(boat)
    # HullType logic already ported to model
    HullType.all_options.find { |o| o.value == boat.hull_type }&.name || boat.hull_type
  end
  
  def human_weight(boat)
    return "N/A" unless boat.boat_weight
    case boat.boat_weight.name
    when "hwt" then "Heavyweight"
    when "mwt" then "Midweight"
    when "lwt" then "Lightweight"
    else boat.boat_weight.name.capitalize
    end
  end
end
