class Boat < ActiveRecord::Base
  has_many :events
  belongs_to :boat_usage
  belongs_to :boat_weight
  
  validates_presence_of :name, :hull_type, :boat_usage, :boat_weight
  validates_format_of :hull_type, 
                      :with => /^[1,2,4,8][X,x,\-,\+]/,
                      :message  => "is not a valid type"
  validates_uniqueness_of :name
  
  def has_coxswain?
    ( self.hull_type =~ /[\+]/ ) != nil
  end
  
  def max_number_of_rowers
    return ( self.hull_type[0,1] ).to_i
  end
  
  def human_type
    ht = HullType
    HULL_OPTIONS.each do |h_option|
      h_option.options.each do |option|
        if option.value == self.hull_type
           return option.name
        end
      end
    end
    return nil
  end

  def check_availability(date, start, finish)
    events = self.events.find :all, :conditions => ["event_on = ?", date]
    return nil if events.length == 0
    events.each do |e|
      return nil if ((start < e.start_time) && (finish <= e.start_time))
      return nil if ((start >= e.end_time) && (finish > e.end_time))
      if (e.is_on?)
        message = "#{e.team.name} crew is using the #{self.name} from #{e.start_time.strftime("%H:%M")} to #{e.end_time.strftime("%H:%M")} (boat full)"
      else
        message = "#{e.team.name} crew is possibly using the #{self.name} from #{e.start_time.strftime("%H:%M")} to #{e.end_time.strftime("%H:%M")} (boat not full)"
      end
      return message if ((start >= e.start_time) && (finish <= e.end_time))
      return message if ((start <= e.start_time) && (finish <= e.end_time))
      return message if ((start >= e.start_time) && (finish >= e.end_time))
      return message if ((start <= e.start_time) && (finish >= e.end_time))
    end
    return nil
  end
  
  def rowing_history(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day #set Sunday as beginning of week
    history = Array.new(time_period, 0)
    events = self.events.find :all, :conditions => ["event_on <= ? AND event_on > ?", todays_date, (start_of_week - time_period.to_i.weeks)], :order => "event_on DESC"
    events.each do |event|
      if event.is_on?
        0.upto(time_period.to_i) { |i|
          history[i] = 0 if history[i].nil?
          if (event.event_on >= start_of_week - i.weeks)
            history[i] += 1
            break
          end
        }
      end
    end
    return history
  end
  
  def completed_events(time_period = 24)
    todays_date = Date.today
    start_of_week = todays_date.beginning_of_week - 1.day #set Sunday as beginning of week
    completed = []
    events = self.events.find :all, :conditions => ["event_on <= ? AND event_on > ?", todays_date, (start_of_week - time_period.to_i.weeks)], :order => "event_on DESC"
    events.each do |event|
      if event.is_on?
        completed << event
      end
    end
    return completed
  end
end
