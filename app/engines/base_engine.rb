class BaseEngine

  attr_reader :robot, :logger

  def initialize(_robot)
    @robot = _robot
    @logger = RobotLoggerService.new _robot
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

  def log_exception(_exc)
    logger.error("#{_exc.class}: #{_exc.message}")
    _exc.backtrace.each { |l| logger.error l } if _exc.backtrace # TODO: this could be a little taxing on DB..
  end

  def stat(_name, _options={}, &_block)
    stat = RobotStatService.new robot, _name
    if _block
      return if _options.key? :at and !stat.can_run_if_runs_at? _options[:at]
      return if _options.key? :every and !stat.can_run_if_runs_every? _options[:every]
      stat.record _block.call
    else
      stat.record _options
    end
  end

  def alert(_title, _message = nil)
    logger.warn "Alert: #{_message || _title}"
    TriggerRobotAlert.new(robot: robot, title: _title, message: _message).perform
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
