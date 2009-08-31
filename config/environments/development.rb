# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = true
# notice this is on to get "A copy of XX has been removed from the module tree but is still active!" errors
# to stop showing up.  Now must restart server when models change  -slm 08/31/2009

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

YOURSITE = 'localhost:3000'

# For recaptcha use
#ENV['RECAPTCHA_PUBLIC_KEY']  = "6LfVYwEAAAAAAMYncwBwFkzwN4qCKLc08bJbtnCA" #heroku
#ENV['RECAPTCHA_PRIVATE_KEY'] = "6LfVYwEAAAAAAN9Zq-64_zXBzoF5pvVM9JhgOs8c" #heroku
ENV['RECAPTCHA_PUBLIC_KEY']  = "6LfQYwEAAAAAAKlcAvQyWiUuhK2MsLWdAg2NetNG" #development
ENV['RECAPTCHA_PRIVATE_KEY'] = "6LfQYwEAAAAAALns-mpDvMoNBUbnxlQW16E91ZRU" #development
