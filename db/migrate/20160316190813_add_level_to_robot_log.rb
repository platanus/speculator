class AddLevelToRobotLog < ActiveRecord::Migration
  def change
    add_column :robot_logs, :level, :string
  end
end
