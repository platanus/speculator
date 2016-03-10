class Order < ActiveRecord::Base
  extend Enumerize

  enumerize :instruction, :in => { Trader::Order::BID => 0, Trader::Order::ASK => 1 }, scope: true

  belongs_to :account

  validates :ex_id, :volume, :price, :base_currency, :quote_currency, presence: true

  before_create :load_defaults

  def self.unsynced
    where('unsynced_volume > 0')
  end

  def self.open
    where(closed_at: nil)
  end

  def open?
    closed_at.nil?
  end

  private

  def load_defaults
    self.pending_volume = volume if pending_volume.nil?
    self.unsynced_volume = volume - pending_volume
  end
end

# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  account_id      :integer
#  ex_id           :string(255)
#  price           :float(24)
#  volume          :float(24)
#  pending_volume  :float(24)
#  unsynced_volume :float(24)        default(0.0)
#  instruction     :integer
#  closed_at       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  base_currency   :string(255)
#  quote_currency  :string(255)
#
# Indexes
#
#  index_orders_on_account_id  (account_id)
#
