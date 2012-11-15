ActionMailer::Base.smtp_settings = {
  address: "smtp.gmail.com",
  port: 587,
  domain: "yarmouth-rowing.org",
  authentication: "plain",
  enable_starttls_auto: true,
  user_name: "scheduler@yarmouth-rowing.org",
  password: "L;prj510GT"
}

Mail.register_interceptor(DevelopmentMailInterceptor) unless Rails.env.production?