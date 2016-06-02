class YamlEngine < BaseEngine
  attr_reader :params

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
    @params = _config.merge fixed_config
    perform
  end

  def perform
    raise NotImplementedError, '`perform` method not implemented'
  end

  def fixed_config
    { 'delay' => robot.delay }
  end
end
