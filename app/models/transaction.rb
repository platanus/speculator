class Transaction < ActiveRecord::Base
  extend Enumerize

  belongs_to :account

  enumerize :instruction, :in => { Trader::Order::BID => 0, Trader::Order::ASK => 1 }, scope: true

  validates :account, :timestamp, :price, :volume, presence: true
end

# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  account_id  :integer
#  timestamp   :datetime
#  price       :float(24)
#  volume      :float(24)
#  instruction :integer
#
# Indexes
#
#  index_transactions_on_account_id                (account_id)
#  index_transactions_on_account_id_and_timestamp  (account_id,timestamp)
#
# Foreign Keys
#
#  fk_rails_01f020e267  (account_id => accounts.id)
#
