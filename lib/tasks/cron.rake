task :cron => :environment do
  Time.zone = 'Eastern Time (US & Canada)'
  Event.daily_notify
end

namespace :notifier do
  task :time => :environment do
    puts Time.zone.now
    puts Event.last.start_time.strftime('%H:%M %p')
    Time.zone = 'Eastern Time (US & Canada)'
    puts Time.zone.now
    puts Event.last.start_time.strftime('%H:%M %p')
  end
end