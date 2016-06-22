class RobotLoggerService
  def initialize(_robot)
    @robot = _robot
  end

  def log(_message, _level=:info)
    Rails.logger.public_send(_level, _message)
    robot.logs.create! message: _message, level: _level
  end

  def info(_message)
    log(_message, :info)
  end

  def warn(_message)
    log(_message, :warn)
  end

  def error(_message)
    log(_message, :error)
  end

  private

  def notify_error(_message)
    NotifyRobot.for robot: robot, say: "error detected! #{_message}"
  end

  attr_reader :robot
end
