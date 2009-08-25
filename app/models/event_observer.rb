class EventObserver < ActiveRecord::Observer
  def after_save(event)
    EventNotifier.deliver_rowing_notification(event) if event.is_on? && event.event_on > Date.today
  end
end