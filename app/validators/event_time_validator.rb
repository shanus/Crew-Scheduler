class EventTimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value, time = Time.now)
    if (!value.nil?)
      if !record.starts_at.nil?
        record.errors[attribute] << I18n.t('model.errors.custom.starts_at') if record.starts_at < time
        if !record.ends_at.nil?
          record.errors[attribute] << I18n.t('model.errors.custom.ends_at') if record.starts_at >= record.ends_at
        end
      end
    end
  end
end