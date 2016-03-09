class CreateRobotLogs < ActiveRecord::Migration
  def change
    create_table :robot_logs do |t|
      t.belongs_to :robot, index: true, foreign_key: true
      t.datetime :created_at
      t.text :message
    end
  end
end
