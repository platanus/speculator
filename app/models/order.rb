class Order < ActiveRecord::Base
  extend Enumerize

  enumerize :instruction, :in => { Trader::Order::TYPE_BID => 0, Trader::Order::TYPE_ASK => 1 }, scope: :true

  belongs_to :account

  before_validation :create_or_sync, on: :create
  validate :has_required_attributes

  def self.unsynced
    where('unsynced_volume > 0')
  end

  def self.open
    where(closed_at: nil)
  end

  def self.flush
    # TODO.
  end

  def refresh!
    core_order.refresh!
    sync_with_core
    save!
  end

  def cancel!
    core_order.cancel!
    sync_with_core
    save!
  end

  def open?
    closed_at.nil?
  end

  def pair
    account.pair
  end

  def volume
    pair.base.pack read_attribute(:volume)
  end

  def pending_volume
    pair.base.pack read_attribute(:pending_volume)
  end

  def price
    pair.quote.pack read_attribute(:price)
  end

  def core_order
    @core ||= account.find_position ex_id
  end

  private

  def has_required_attributes
    if ex_id.nil?
      errors.add(:volume, 'must provide a volume') if read_attribute(:volume).nil?
      errors.add(:price, 'must provide a price') if read_attribute(:price).nil?
      errors.add(:instruction, 'must provide an instruction') if instruction.nil?
    end
  end

  def create_or_sync
    if ex_id.nil?
      @core = account.core_account.public_send(instruction, read_attribute(:volume), read_attribute(:price))
      self.ex_id = @core.id
    end

    self.pending_volume = 0.0
    sync_with_core
  end

  def sync_with_core
    self.price = core_order.price.amount
    self.volume = core_order.volume.amount
    self.unsynced_volume += (read_attribute(:pending_volume) - core_order.pending_volume.amount)
    self.pending_volume = core_order.pending_volume.amount
    self.closed_at = Time.current if closed_at.nil? and core_order.finished?
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
#
# Indexes
#
#  index_orders_on_account_id  (account_id)
#
