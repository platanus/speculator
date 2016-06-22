class AddSlackTokenToRobot < ActiveRecord::Migration
  def change
    add_column :robots, :slack_token, :string
    add_column :robots, :slack_channel, :string
  end
end
