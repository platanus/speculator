class CreateRobotConfigChanges < ActiveRecord::Migration
  def change
    create_table :robot_config_changes do |t|
      t.belongs_to :robot, index: true, foreign_key: true
      t.text :config
      t.datetime :created_at
    end
  end
end
