module UsersHelper
  def sparkline_data
    @sparkline_data ||= current_user.rowing_history
  end
  
  def user_color(user)
    if user.color.blank?
      html = ""
    else 
     html = ' style="border-bottom:6px solid '
     html << user.color
     html << ';"'
    end
    return html
  end
end
