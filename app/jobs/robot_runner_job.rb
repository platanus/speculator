class RobotRunnerJob < ActiveJob::Base
  queue_as :default

  def perform(_robot, *_args)
    Rails.logger.info "Executing robot: #{_robot.name}"
    _robot.load_engine.tick
    _robot.try_set_finished
  rescue Exception => exc
    Rails.logger.error "Error while executing robot: #{exc.message}"
    Rails.logger.error exc.backtrace.join "\n"

    _robot.try_set_finished(exc)
  end
end
