module SummaryHelper
  def seats_needed(event)
    return "" if event.nil? || event.boat.nil?
    
    max_rowers = event.boat.max_number_of_rowers
    needed = []
    
    (1..max_rowers).each do |i|
      label = if max_rowers == 1
                "single"
              elsif i == max_rowers
                "stroke"
              elsif i == 1
                "bow"
              else
                i.to_s
              end
      
      # Assuming event.rowers is a hash or similar from the legacy models
      # In our modern model, we check seating_positions
      seat = event.seating_positions.find_by(position: i)
      needed << label if seat&.user_id.nil?
    end
    
    needed << "coxswain" if event.needs_coxswain?
    needed << "coach" if event.needs_coach?
    
    needed.join(", ")
  end
end
