class YamlEngine < BaseEngine
  def self.config_lang
    'yaml'
  end

  private

  def load_configuration(_raw)
    YAML.load _raw
  end

  def dump_configuration(_raw)
    YAML.dump _raw
  end

  def generate_default_configuration
    nil
  end

  def validate_configuration(_config)
    _config.is_a? Hash
  end

  def perform_with_configuration(_config)
    perform_with_hash(_config.merge fixed_config)
  end

  def perform_with_hash(_config)
    raise NotImplementedError, '`perform_with_hash` method not implemented'
  end

  def fixed_config
    { 'delay' => robot.delay }
  end
end
