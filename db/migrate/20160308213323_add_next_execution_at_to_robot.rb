class AddNextExecutionAtToRobot < ActiveRecord::Migration
  def change
    add_column :robots, :delay, :integer
    add_column :robots, :started_at, :datetime
    add_column :robots, :next_execution_at, :datetime, index: true
  end
end
