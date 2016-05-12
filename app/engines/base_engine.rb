class BaseEngine
  attr_reader :robot, :logger

  def initialize(_robot)
    @robot = _robot
    @logger = RobotLoggerService.new _robot
  end

  def valid_configuration?
    validate_configuration load_configuration robot.config
  end

  def default_raw_configuration
    dump_configuration generate_default_configuration
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

  def end_alert(_title)
    if EndRobotAlert.new(robot: robot, title: _title).perform
      logger.info "Alert ended: #{_title}"
    end
  end

  def tick
    robot_context.apply do
      perform_with_configuration load_configuration robot.config
    end
  rescue Exception => exc
    log_exception exc
  end

  private

  def load_configuration(_raw) # abstract
    _raw
  end

  def dump_configuration(_raw) # abstract
    _raw
  end

  def generate_default_configuration # abstract
    nil
  end

  def validate_configuration(_config) # abstract
    true
  end

  def perform_with_configuration(_config) # abstract
    raise NotImplementedError, '`perform_with_configuration` method not implemented'
  end

  def robot_context
    RobotContextService.new robot
  end

  def accounts
    @accounts ||= robot.accounts.map { |a| SyncAccount.new a }
  end
end
