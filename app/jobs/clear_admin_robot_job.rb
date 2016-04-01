class ClearAdminRobotJob < ActiveJob::Base
  queue_as :default

  def perform(_robot, *_args)
    Rails.logger.info "Clearing robot: #{_robot.name}"
    RobotAdminService.new(_robot).cancel_every_order
  end
end
