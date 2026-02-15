class SummaryController < ApplicationController
  def index
    @page_title = "Scheduler: Summary"
    @bulletins = Bulletin.where("display_until >= ?", Date.today).order(created_at: :desc)
    @today = Event.today
    @tomorrow = Event.tomorrow
    @day_after = Event.day_after_tomorrow
    @needed = Event.needed
    @tide = Tide.today
  end
end
