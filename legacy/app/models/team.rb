class Team < ActiveRecord::Base
  has_many :users
  has_many :events
  validates_presence_of :name
  
  def get_all
    team.find(:all)
  end
  
  def members
    self.users
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
