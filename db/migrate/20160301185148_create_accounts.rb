class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :robot, index: true
      t.string :name
      t.string :exchange
      t.string :base_currency
      t.string :quote_currency
      t.text :encrypted_credentials

      t.timestamps null: false
    end
  end
end
