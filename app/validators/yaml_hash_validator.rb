class YamlHashValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      result = YAML.load value
      record.errors[attribute] << "YAML is not a hash" unless result.is_a? Hash
    rescue
      record.errors[attribute] << "invalid YAML"
    end
  end
end
