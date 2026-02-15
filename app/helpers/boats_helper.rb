module BoatsHelper
  def boat_icon(boat)
    # Modernized to look for icon in assets/boats/
    # Replaces + with plus and - with minus for filename safety
    icon_name = boat.hull_type.to_s.gsub("+", "plus").gsub("-", "minus")

    # Try to find the image, fallback to a placeholder if not found
    begin
      image_tag "boats/#{icon_name}_48.gif", alt: boat.name, class: "boat-icon shadow-sm"
    rescue ActionView::AssetPaths::AssetNotPrecompiledError, ActionView::Helpers::AssetTagHelper::AssetNotFoundError
      # Fallback to a generic icon if specific icon is missing
      content_tag(:i, "", class: "bi bi-layers fs-3 text-secondary")
    end
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
