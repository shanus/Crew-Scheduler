module UsersHelper
  def pretty_city_state(user)
    html = ""
    if (user.country == "US" || user.country.nil?)
      html << h(user.city) + ", " unless user.city.blank?
      html << h(user.state) + " " unless user.state.blank?
    else
      html << h(user.city) + ", " unless user.city.blank?
      html << h(Carmen::country_name(user.country)) + " " unless user.country.blank?
    end
    html.sub!(/\,\s?$/," ")
    return "" if html.strip == ","
    html.strip
  end
  
  def gravatar_url(user, size = 48)
    if user.has_attribute?(:avatar_url) && user.avatar_url.present?
      # have this option for future omni auth avatar capabilities -slm 03/27/2012
      user.avatar_url
    else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm&r=pg"
    end
  end
end