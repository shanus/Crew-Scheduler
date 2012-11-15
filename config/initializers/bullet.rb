if (Rails.env.development? && (defined? Bullet))
  Bullet.enable = true
  Bullet.bullet_logger = true
  Bullet.alert = false # turn on to get javascript alert dialog
end