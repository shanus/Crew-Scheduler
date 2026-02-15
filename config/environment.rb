# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: Rails.application.credentials.dig(:smtp, :user_name),
  password: Rails.application.credentials.dig(:smtp, :password),
  address: "email-smtp.us-east-1.amazonaws.com",
  port: 587,
  domain: "yarmouth-rowing.org",
  authentication: "plain",
  tls: true
}