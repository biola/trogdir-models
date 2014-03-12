require 'uri'

class AbsoluteUriValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      unless URI.parse(value).absolute?
        record.errors[attribute] << 'is not an absolute URL'
      end
    rescue URI::InvalidURIError => error
      record.errors[attribute] << 'is not a valid URL'
    end
  end
end