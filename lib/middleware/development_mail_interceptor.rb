class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[normally sent to #{message.to}] #{message.subject}"
    message.to = Rails.env.staging? ? "testing+gspstaging@infobridge.net" : "testing+gsp@infobridge.net"
  end
end