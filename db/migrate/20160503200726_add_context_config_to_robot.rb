class AddContextConfigToRobot < ActiveRecord::Migration
  def change
    add_column :robots, :context_config, :text
  end
end
