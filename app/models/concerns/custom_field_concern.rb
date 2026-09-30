module CustomFieldConcern
  extend ActiveSupport::Concern

  def validate_field
    if self.custom_field
      if self.custom_field.required
        if self.field_value.blank?
          self.errors.add(:field_value, I18n.t('activerecord.errors.messages.blank'))
        end
      end
      if self.custom_field.required and self.field_value.present?
        if self.custom_field.format_regexp.present?
          unless self.field_value =~ /#{self.custom_field.format_regexp}/
            self.errors.add(:field_value, I18n.t('activerecord.errors.messages.format_invalid'))
          end
        end
      elsif self.field_value.present?
        if self.custom_field.format_regexp.present?
          unless self.field_value =~ /#{self.custom_field.format_regexp}/
            self.errors.add(:field_value, I18n.t('activerecord.errors.messages.format_invalid'))
          end
        end
      end
    end
  end
end
