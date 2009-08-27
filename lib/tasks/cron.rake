task :cron => :environment do
  Event.daily_notify
end