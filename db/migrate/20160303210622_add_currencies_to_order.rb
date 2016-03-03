class AddCurrenciesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :base_currency, :string
    add_column :orders, :quote_currency, :string
  end
end
