source 'https://rubygems.org'
gem 'rails', '3.2.13'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
	gem 'therubyracer', :platforms => :ruby
end
gem 'jquery-rails'
gem "less-rails"
gem "twitter-bootstrap-rails"
gem 'jquery-datatables-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-colorpicker-rails'
gem 'bootstrap-datepicker-rails', "~> 0.6.24"
gem 'bootstrap-timepicker-rails'
gem 'rails-bootstrap-toggle-buttons'
gem 'markitup-rails'

gem 'thin'
gem "dalli"
gem "devise", ">= 2.1.2"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem 'carmen'
gem 'truncate_html'
gem 'cocoon'
gem 'kaminari'
gem 'sidekiq'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'date_validator'
gem 'bluecloth'
gem 'validates_timeliness'

group :test do
  gem "capybara", ">= 1.1.3"
  gem "launchy", ">= 2.1.2"
  gem "cucumber-rails", ">= 1.3.0", :require => false
  gem "email_spec", ">= 1.4.0"
  gem "database_cleaner", ">= 0.9.1"
end

group :development do
  gem "quiet_assets", ">= 1.0.1"
  gem 'sqlite3'
	gem 'bullet'
  gem 'rails-erd'
	gem 'nifty-generators'
	gem 'hirb'
end

group :development, :test do
  gem "factory_girl_rails", ">= 4.1.0"
  gem "rspec-rails", ">= 2.11.4"
end

group :production do
  gem 'pg'
  gem 'exception_notification'
end