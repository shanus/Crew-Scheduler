# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  config.gem "fastercsv", :version => '>=1.4'
  config.gem 'mislav-will_paginate', :version => '~> 2.3.8', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'bluecloth'
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  
  # Added for ActionMailer to work with Acts_as_authenticated
  config.active_record.observers = :user_observer, :event_observer
  
  config.time_zone = 'UTC'
end


# Include your application configuration below
SUPPORTEMAIL = 'webmaster@yarmouth-rowing.org' unless defined? SUPPORTEMAIL
ADMINEMAIL = 'scheduler@yarmouth-rowing.org' unless defined? ADMINEMAIL
YOURSITE = 'scheduler.yarmouth-rowing.org' unless defined? YOURSITE

# Google Calendar and email items
EVENTCALENDAR = "http://www.google.com/calendar/hosted/yarmouth-rowing.org/embed?src=scheduler%40yarmouth-rowing.org&ctz=America/New_York" unless defined? EVENTCALENDAR
TIDECALENDAR = "http://www.google.com/calendar/hosted/yarmouth-rowing.org/embed?src=yarmouth-rowing.org_0ingqags0ib0vuutvegtjckopg%40group.calendar.google.com&ctz=America/New_York&color=%2328754E&mode=WEEK" unless defined? TIDECALENDAR
TIDECALENDARNAME = "Tides" unless defined? TIDECALENDARNAME
GMAIL = "scheduler@yarmouth-rowing.org" unless defined? GMAIL
GMAILPASSWD = "L;prj510GT" unless defined? GMAILPASSWD

# RSS Items
BULLETINRSSTITLE = "Yarmouth Rowing Club Bulletins" unless defined? BULLETINRSSTITLE
BULLETINRSSDESC = "The latest bulletins and announcements from Yarmouth Rowing Club." unless defined? BULLETINRSSDESC

# Configure the exception notifier
ExceptionNotifier.exception_recipients = %w(shaun+polarrowing@yarmouth-rowing.org)
ExceptionNotifier.sender_address = %("Scheduler Error" <polarrowing@gmail.com>)
ExceptionNotifier.email_prefix = "[Polar Rowing Scheduler ERROR] "  

ActionMailer::Base.smtp_settings = {
 :user_name => GMAIL,
 :password => GMAILPASSWD,
 :authentication => :plain,
 :address  => "smtp.gmail.com",
 :port  => 587, 
 :tls => true,
 :domain  => 'gmail.com'
}

require 'fastercsv'

#daily notifications using rufus-scheduler gem
# require 'rufus/scheduler'
# scheduler = Rufus::Scheduler.start_new
# 
# scheduler.schedule("0 15 * * *") do
#   Event.daily_notify
# end



