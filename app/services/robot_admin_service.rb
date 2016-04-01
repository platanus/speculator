class RobotAdminService
  attr_reader :robot

  def initialize(_robot)
    @robot = _robot
  end

  def cancel_every_order
    # This should lock the robot to prevent it from starting
    RobotContextService.new(robot).apply do
      robot.accounts.each do |account|
        SyncAccount.new(account).cancel_every_order
      end
    end
  end
end
