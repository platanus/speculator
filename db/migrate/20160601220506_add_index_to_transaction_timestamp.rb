class AddIndexToTransactionTimestamp < ActiveRecord::Migration
  def change
    add_index :transactions, [:account_id, :timestamp]
  end
end
