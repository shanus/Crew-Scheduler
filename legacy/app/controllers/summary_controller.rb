class SummaryController < ApplicationController

  def index
    @page_title = "Scheduler: Summary for #{current_user.name.capitalize}"
    @tabs = Team.find :all
    @tides = Tide.find :all, :conditions=> [ "day >= ?", Time.now - 1.day ], :order => "day ASC", :limit => 3
    @total_bulletins = Bulletin.count :all, :conditions => ["display_until >= ?", Time.now ]
    @bulletins = Bulletin.find :all, :conditions => ["display_until >= ?", Time.now ], :order=> 'created_at DESC', :limit => 3
    @today = Event.today
    @tomorrow = Event.tomorrow
    @day_after_tomorrow = Event.day_after_tomorrow
    @myevents = @current_user.upcoming
    @needed = Event.needed
  end 
end
