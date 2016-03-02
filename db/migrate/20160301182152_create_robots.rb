class CreateRobots < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.string :name
      t.string :engine
      t.text :config
      t.datetime :last_execution_at

      t.timestamps null: false
    end
  end
end
