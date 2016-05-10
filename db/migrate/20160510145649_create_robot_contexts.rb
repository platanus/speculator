class CreateRobotContexts < ActiveRecord::Migration
  def change
    create_table :robot_contexts do |t|
      t.text :config

      t.timestamps null: false
    end
  end
end
