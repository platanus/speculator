class EndRobotAlert < Command.new(:robot, :title)
  def perform
    alert = robot.alerts.live.where(title: title).first
    return false if alert.nil?
    alert.update_column :triggered_at, nil
    return true
  end
end
