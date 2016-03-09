class ChangeDelayType < ActiveRecord::Migration
  def up
    change_column :robots, :delay, :float
  end

  def down
    change_column :robots, :delay, :integer
  end
end
