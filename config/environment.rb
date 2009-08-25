# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql
  config.action_controller.session = {
    :session_key => '_scheduler_session',
    :secret      => '5a65c402d60bf99c16d1c72e79e18802row216a46fde9dmy98dog6f43957c03a4f40a209989476c22f6bdd13niced092d769ca0d2cc1ec7lYt0f1336e2dde354'
  }
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  
  # Added for ActionMailer to work with Acts_as_authenticated
  config.active_record.observers = :user_observer, :event_observer
  
  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

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

# Time offset (needed due to heroku server being in different timezone, could be handled differently but works for now)
TIMEZONE = Time.now.zone unless defined? TIMEZONE
TIMEOFFSET = Time.now.gmt_offset - Time.zone_offset(TIMEZONE)

# Configure the exception notifier
ExceptionNotifier.exception_recipients = %w(shaun@yarmouth-rowing.org)
ExceptionNotifier.sender_address = %("Scheduler Error" <scheduler@yarmouth-rowing.org>)
ExceptionNotifier.email_prefix = "[Scheduler ERROR] "  

ActionMailer::Base.smtp_settings = {
 :user_name => GMAIL,
 :password => GMAILPASSWD,
 :authentication => :plain,
 :address  => "smtp.gmail.com",
 :port  => 587, 
 :tls => true,
 :domain  => 'yarmouth-rowing.org'
}

require 'fastercsv'

#daily notifications using rufus-scheduler gem
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.start_new

scheduler.schedule("0 15 * * *") do
  Event.daily_notify
end



