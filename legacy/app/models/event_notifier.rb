class EventNotifier < ActionMailer::Base
  def rowing_notification(event)
    setup_email(event)
    @subject    += "Rowing (#{event.team.name} crew) on #{event.event_on.strftime('%m-%d-%Y')} at #{event.start_time.strftime('%H:%M %p')}"
  end
  
  def reminder(event, recipients)
    setup_reminder_email(event, recipients)
    @subject    += "Rowing REMINDER"
  end
  
  protected
  def setup_email(event)
    @recipients = event.rowers_email
    @recipients << event.coach_email unless event.coach_email.nil?
    @recipients << event.coxswain_email unless event.coxswain_email.nil?
    @from        = "#{ADMINEMAIL}"
    @subject     = "[#{YOURSITE}] "
    @sent_on     = Time.now
    @body[:event] = event
  end
  
  def setup_reminder_email(event, recipients)
    @recipients  = recipients.collect { |u| u.email }
    @from        = "#{ADMINEMAIL}"
    @subject     = "[#{YOURSITE}] "
    @sent_on     = Time.now
    @body[:event] = event
  end
end