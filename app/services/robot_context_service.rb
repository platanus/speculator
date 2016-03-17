require "trade-o-matic/support/converter_configurator"

class RobotContextService
  attr_reader :robot

  def initialize(_robot)
    @robot = _robot
  end

  def apply
    Trader::Currency.isolate_conversions do
      load_conversions config['conversions']
      yield
    end
  end

  private

  def config
    @config ||= robot.context_config
  end

  def load_conversions(_config)
    Trader::ConverterConfigurator.from_yaml _config if _config
  end
end
