require 'forwardable'

class SyncOrder
  extend Forwardable

  attr_reader :order, :account

  def_delegators :order, :instruction, :ex_id, :open?

  def initialize(_order, _core=nil)
    @order = _order
    @core = _core
  end

  def pair
    @pair ||= Trader::CurrencyPair.for_code(order.base_currency.to_sym, order.quote_currency.to_sym)
  end

  def volume
    pair.base.pack order.volume
  end

  def pending_volume
    pair.base.pack order.pending_volume
  end

  def price
    pair.quote.pack order.price
  end

  def save!
    sync_with_core
    order.save!
  end

  def refresh!
    core_order.refresh!
    save!
  end

  def cancel!
    core_order.cancel!
    save!
  end

  def core_order
    @core ||= load_core_order
  end

  private

  def load_core_order
    account = SyncAccount.new order.account
    account.core_account.find_order ex_id
  end

  def sync_with_core
    if order.persisted?
      order.unsynced_volume += order.pending_volume - pair.base.unpack(core_order.pending_volume) # pending volume should only decrease
      order.pending_volume = pair.base.unpack core_order.pending_volume
    else
      order.ex_id = core_order.id
      order.instruction = core_order.type
      order.base_currency = core_order.volume.currency.code
      order.volume = core_order.volume.amount
      order.quote_currency = core_order.price.currency.code
      order.price = core_order.price.amount
      order.pending_volume = core_order.pending_volume.amount
    end

    order.closed_at = Time.current if order.closed_at.nil? and core_order.finished?
  end
end
