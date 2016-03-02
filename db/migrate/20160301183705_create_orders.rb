class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :account, index: true
      t.string :ex_id
      t.float :price
      t.float :volume
      t.float :pending_volume
      t.float :unsynced_volume, default: 0
      t.integer :instruction
      t.datetime :closed_at, default: nil

      t.timestamps null: false
    end
  end
end
