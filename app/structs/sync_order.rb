require 'forwardable'

class SyncOrder
  extend Forwardable

  attr_reader :order, :account

  def_delegators :order, :instruction, :ex_id, :open?

  def initialize(_order)
    @order = _order
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

  def bind!(_core_order)
    @core = _core_order
    bind_to_core
    order.save!
  end

  def refresh!
    core_order.refresh!
    sync_with_core
    order.save!
  end

  def cancel!
    core_order.cancel!
    sync_with_core
    order.save!
  end

  def account
    @account ||= SyncAccount.new order.account
  end

  def account=(_account)
    @account = _account
  end

  def core_order
    @core ||= account.core_account.find_order ex_id
  end

  private

  def bind_to_core
    order.ex_id = core_order.id
    order.instruction = core_order.type
    order.base_currency = core_order.volume.currency.code
    order.volume = core_order.volume.amount
    order.quote_currency = core_order.price.currency.code
    order.price = core_order.price.amount
    order.pending_volume = core_order.pending_volume.amount
    sync_status
  end

  def sync_with_core
    order.unsynced_volume += order.pending_volume - pair.base.unpack(core_order.pending_volume) # pending volume should only decrease
    order.pending_volume = pair.base.unpack core_order.pending_volume
    sync_status
  end

  def sync_status
    order.closed_at = Time.current if order.closed_at.nil? and core_order.finished?
  end
end
