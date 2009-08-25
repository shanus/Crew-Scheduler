module SummaryHelper
  def seats_needed(event)
		seats_needed = ""
		1.upto(event.boat.max_number_of_rowers) { |i|
			seat = "#{i}"
			if (event.boat.max_number_of_rowers==1)
				seat = "single"
			elsif (i==event.boat.max_number_of_rowers)
				seat = "stroke"
			elsif (i==1)
				seat = "bow"
			end 
			seats_needed = "#{seats_needed}#{seat}, " if event.rowers[i].nil?
		} 
		seats_needed = "#{seats_needed}coxswain, " if event.needs_coxswain?
		seats_needed = "#{seats_needed}coach, " if event.needs_coach?
		seats_needed.rstrip.sub(/,$/,'')
  end
end
