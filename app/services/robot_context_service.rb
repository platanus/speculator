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

  def robot_context
    @robot_context ||= robot.context
  end

  def config
    @config = robot_context.decoded_config
  end

  def load_conversions(_config)
    Trader::ConverterConfigurator.from_yaml _config if _config
  end
end
