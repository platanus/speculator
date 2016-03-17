class BaseEngine

  attr_reader :robot

  def initialize(_robot)
    @robot = _robot
  end

  def get_account(_name=nil)
    picks = get_accounts(_name)
    raise ArgumentError, "No account found for name #{_name}" if picks.count == 0
    raise ArgumentError, "More than one account is available as #{_name}" if picks.count > 1
    picks.first
  end

  def get_accounts(_name=nil)
    return accounts.clone if _name.nil?
    accounts.select { |a| a.name == _name.to_s }
  end

  def log(_message, _level=:info)
    Rails.logger.public_send(_level, _message)
    robot.logs.create! message: _message, level: _level
  end

  def log_exception(_exc, _level=:error)
    log("#{_exc.class}: #{_exc.message}", _level)
    _exc.backtrace.each { |l| log(l, _level) } if _exc.backtrace # TODO: this could be a little taxing on DB..
  end

  def tick
    robot_context.apply do
      unpack_config robot.engine_config
      perform
    end
  rescue Exception => exc
    log_exception exc
  end

  # TODO: provide alert generation methods to engines

  # Abstract methods:

  def unpack_config(_config)
    raise NotImplementedError, '`unpack_config` method not implemented'
  end

  def perform
    raise NotImplementedError, '`perform` method not implemented'
  end

  private

  def robot_context
    RobotContextService.new robot
  end

  def accounts
    @accounts ||= robot.accounts.map { |a| SyncAccount.new a }
  end
end
