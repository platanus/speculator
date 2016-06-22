class NotifyRobot < Command.new(:robot, :say)
  def perform
    notify_via_slack("Yo! #{say}") if slack_enabled?
  end

  private

  def slack_enabled?
    !(robot.slack_token.blank? || robot.slack_channel.blank?)
  end

  def notify_via_slack(_message)
    begin
      client = Slack::Web::Client.new(token: robot.slack_token)
      client.chat_postMessage(
        channel: robot.slack_channel || '#general',
        text: _message,
        as_user: true
      )
    rescue => exc
      Rails.logger.error "Failed to notify robot #{robot.name} using Slack"
      Rails.logger.error exc.message
      Rails.logger.error exc.backtrace.join("\n")
    end
  end

  def notify_via_email(_message)
    # TODO.
  end
end
