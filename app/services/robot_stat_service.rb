class RobotStatService
  attr_reader :robot, :name

  TIME_RGX = /(\d\d|\*\*):(\d\d)/

  def initialize(_robot, _name)
    @robot = _robot
    @name = _name
  end

  def can_run_if_runs_at?(_time)
    day_offset = parse_time_exp _time
    return false if current_time.seconds_since_midnight < day_offset
    return true if last_point.nil?
    return true if last_point.created_at.to_date < current_time.to_date
    return false if last_point.created_at.seconds_since_midnight > day_offset
    true
  end

  def can_run_if_runs_every?(_delay)
    raise ArgumentError, 'invalid delay' unless _delay.is_a? ActiveSupport::Duration
    return true if last_point.nil?
    return false if (current_time - last_point.created_at.to_time) < _delay
    true
  end

  def record(_value)
    raise ArgumentError, "invalid value  #{_value}" unless _value.is_a? Numeric
    @last_point = robot.stats.create! name: name, value: _value
  end

  def current_time
    Time.current
  end

  private

  def stats
    robot.stats.where(name: name).order('id DESC') # TODO: order by created at?
  end

  def last_point
    @last_point ||= stats.last
  end

  def parse_time_exp(_time)
    m = TIME_RGX.match _time
    raise ArgumentError, 'invalid time string' if m.nil?
    hours, minutes = m[1], m[2]
    hours = current_time.hours if hours == '**'
    hours, minutes = hours.to_i, minutes.to_i
    hours * 3600 + minutes * 60
  end
end
