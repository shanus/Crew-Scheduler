if Rails.env.production?
  APP_NAME = "Crew Scheduler"
else
  APP_NAME = "Crew Scheduler (dev)"
end