class TriggerRobotAlert < Command.new(:robot, :title, :message)
  def perform
    load_alert
    if alert_triggered?
      update_alert
    else
      update_alert
      trigger_alert
      notify_alert
    end
  end

  private

  attr_reader :alert

  def load_alert
    @alert = robot.alerts.where(title: title).first
    @alert = robot.alerts.build title: title if @alert.nil?
  end

  def alert_triggered?
    alert.triggered?
  end

  def update_alert
    alert.triggered_at = current_time unless alert_triggered?
    alert.last_triggered_at = current_time
    alert.message = message || title
    alert.save!
  end

  def trigger_alert
    alert.triggered_at = current_time
  end

  def notify_alert
    NotifyRobot.for robot: robot, say: "alert triggered! #{title}"
  end

  def current_time
    @time ||= Time.current
  end
end
