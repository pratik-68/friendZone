# frozen_string_literal: true

class ImageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?

    return if value.content_type.in?(%w[image/jpeg image/png image/jpg])

    record.errors.add(attribute, 'invalid image type')
  end
end
