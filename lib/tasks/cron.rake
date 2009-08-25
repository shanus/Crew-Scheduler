task :cron => :envrionment do
  Event.daily_notify
end