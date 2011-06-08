module TeamsHelper
  def comma_list(team, email = false)
    list = ''
    team.members.each do |member|
      if email
        text = member.email
      else
        text = mail_to member.email, member.login, :encode => "hex"
      end
			list << "#{text}, "
		end
		(list = 'none') if team.members.count == 0
		list.rstrip.sub(/,$/,'')
  end
  
  def users_javascript
    #content_for(:head) { "<script src='/users/users_for_lookup' type='text/javascript'></script>" }
    script = ""
    script += "<script type='text/javascript'>\n"
    script += "var starboards = new Array(#{@starboards.size});\n"
    @starboards.each_with_index do |starboard, index|
      script += "starboards[#{index}] = \"#{starboard.login}\";\n"
    end
    script += "var ports = new Array(#{@ports.size});\n"
    @ports.each_with_index do |port, index|
      script += "ports[#{index}] = \"#{port.login}\";\n"
    end
    script += "var coaches = new Array(#{@coaches.size});\n"
    @coaches.each_with_index do |coach, index|
      script += "coaches[#{index}] = \"#{coach.login}\";\n"
    end
    script += "var coxswains = new Array(#{@coxswains.size});\n"
    @coxswains.each_with_index do |cox, index|
      script += "coxswains[#{index}] = \"#{cox.login}\";\n"
    end
    script += "</script>"
    content_for(:head) { "#{script}" }
  end
  
  def team_email(team)
    comma_list(team, true)
  end
end
