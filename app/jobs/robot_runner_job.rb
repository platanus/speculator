class RobotRunnerJob < ActiveJob::Base
  queue_as :default

  def perform(_robot, *_args)
    Rails.logger.info "Executing robot: #{_robot.name}"
    _robot.logs.delete_all
    _robot.load_engine.tick
    _robot.try_set_finished
  rescue Exception => exc
    Rails.logger.error "Fatal error while executing robot: #{_robot.name}"
    Rails.logger.error "#{exc.class}: #{exc.message}"
    Rails.logger.error exc.backtrace.join "\n"

    _robot.try_set_finished(exc)
  end
end
