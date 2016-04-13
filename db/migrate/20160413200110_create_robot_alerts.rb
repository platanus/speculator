class CreateRobotAlerts < ActiveRecord::Migration
  def change
    create_table :robot_alerts do |t|
      t.belongs_to :robot, index: true, foreign_key: true
      t.string :title
      t.text :message
      t.datetime :last_triggered_at
      t.datetime :triggered_at
      t.datetime :created_at
    end
  end
end
