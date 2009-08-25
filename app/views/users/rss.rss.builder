xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title(@title)
    xml.link("http://#{YOURSITE}/users/rss/#{@user.login}")
    xml.description(@desc)
    xml.language('en-us')

    for upcoming in @upcoming
      title = "#{human_date(upcoming.event_on, '%A, %m/%d')} @#{human_time upcoming.start_time} with the #{upcoming.team.name.capitalize} Crew in the #{upcoming.boat.name}"

      body = ""     
      body += "#{short_human_date upcoming.event_on}, #{human_time upcoming.start_time} - #{human_time upcoming.end_time}<br />\n<br />\n"
      body += "Boat:#{upcoming.boat.name.capitalize}<br />\n"
      body += "Crew: #{upcoming.team.name.capitalize}<br />\n<br />\n"
      body += "Coach: #{upcoming.coach_name}<br />\n"
      body += "Coxswain: #{upcoming.coxswain_name}<br />\n<br />\n"
      body += "Rowers:<br />\n"
      1.upto(upcoming.boat.max_number_of_rowers) { |i|
        seat = "#{i} seat"
        if (upcoming.boat.max_number_of_rowers==1)
          seat = "single"
        elsif (i==upcoming.boat.max_number_of_rowers)
          seat = "stroke"
        elsif (i==1)
          seat = "bow"
        end
        body += "    #{seat}: #{upcoming.rowers[i]}<br />\n" 
      }
      xml.item do
        xml.title(title)
        xml.category()
        xml.description(body)
        xml.pubDate(upcoming.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link("http://#{YOURSITE}/events/show/" + upcoming.id.to_s)
        xml.guid("http://#{YOURSITE}/events/show/" + upcoming.id.to_s)
        xml.author(upcoming.boat.name.capitalize)
      end
    end
  }
}