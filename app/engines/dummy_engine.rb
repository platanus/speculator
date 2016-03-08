class DummyEngine < BaseEngine

  attr_reader :config

  def unpack_config(_config)
    @config = _config
  end

  def perform

  end

end
