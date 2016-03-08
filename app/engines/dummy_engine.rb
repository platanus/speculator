class DummyEngine

  attr_reader :config

  def initialize(_accounts, _config)
    unpack_config _config
  end

  def unpack_config(_config)
    @config = _config
  end

  def perform

  end

end
