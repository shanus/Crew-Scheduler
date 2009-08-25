task :cron => :environment do
  puts "Sending reminders..."
  User.email_reminders
  puts "done."
end