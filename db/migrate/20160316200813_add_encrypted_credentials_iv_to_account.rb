class AddEncryptedCredentialsIvToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :encrypted_credentials_iv, :string
  end
end
