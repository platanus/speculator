class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :account, index: true, foreign_key: true
      t.datetime :timestamp
      t.float :price
      t.float :volume
      t.integer :instruction
    end
  end
end
