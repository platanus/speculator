class CreateRobotStats < ActiveRecord::Migration
  def change
    create_table :robot_stats do |t|
      t.belongs_to :robot, index: true, foreign_key: true
      t.string :name
      t.float :value
      t.datetime :created_at, null: false
    end
  end
end
