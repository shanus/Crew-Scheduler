Rails.application.config.generators do |g|
  g.orm             = :active_record
  g.template_engine = :erb
  g.test_framework  :test_unit, :fixture => false, :spec => false
  g.stylesheets     = false
  g.javascript      = false
end
