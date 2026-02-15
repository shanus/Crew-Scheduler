module SummaryHelper
  def seats_needed(event)
		seats_needed = ""
		unless event.nil?
		  max_rowers = 1
      if (event.boat)
        max_rowers = event.boat.max_number_of_rowers
      end
  		1.upto(max_rowers) { |i|
  			seat = "#{i}"
  			if (max_rowers==1)
  				seat = "single"
  			elsif (i==max_rowers)
  				seat = "stroke"
  			elsif (i==1)
  				seat = "bow"
  			end 
  			seats_needed = "#{seats_needed}#{seat}, " if event.rowers[i].nil?
  		} 
  		seats_needed = "#{seats_needed}coxswain, " if event.needs_coxswain?
  		seats_needed = "#{seats_needed}coach, " if event.needs_coach?
  	end
		seats_needed.rstrip.sub(/,$/,'')
  end
end
