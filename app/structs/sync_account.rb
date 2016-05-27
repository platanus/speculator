require 'forwardable'

class SyncAccount
  extend Forwardable

  attr_reader :account

  def_delegators :account, :name
  def_delegators :core_account, :market, :base_balance, :quote_balance

  def initialize(_account)
    @account = _account
  end

  def orders(_options={}, &_block)
    orders = account.orders
    orders = orders.with_instruction(_options[:instruction]) if _options.key? :instruction
    orders = orders.open if _options[:open]
    orders = _block.call orders if _block
    orders.map { |o| decorate o }
  end

  def pair
    @pair ||= Trader::CurrencyPair.for_code(account.base_currency.to_sym, account.quote_currency.to_sym)
  end

  def unsynced_volume(_instruction)
    vol = account.orders.with_instruction(_instruction).unsynced.map do |order|
      decorate(order).unsynced_volume
    end.inject(pair.base.pack(0.0), :+)

    pair.base.pack vol
  end

  def sync_volume(_instruction, _volume)
    _volume = pair.base.pack(_volume)

    account.orders.with_instruction(_instruction).unsynced.order('id ASC').each do |order|
      break if _volume <= 0.0
      _volume = decorate(order).sync_volume _volume
    end

    pair.base.pack(_volume)
  end

  def core_account
    @core ||= load_core_account
  end

  def bid(_volume, _price=nil)
    create_order core_account.bid _volume, _price
  end

  def ask(_volume, _price=nil)
    create_order core_account.ask _volume, _price
  end

  def cancel_every_order
    # TODO: add support for backend: cancel all
    orders(open: true).each &:cancel!
  end

  def refresh_open_orders!
    orders(open: true).each &:refresh!
  end

  def unsynced_bid_volume
    unsynced_volume(Trader::Order::BID)
  end

  def unsynced_ask_volume
    unsynced_volume(Trader::Order::ASK)
  end

  def sync_bid_volume(_volume)
    sync_volume(Trader::Order::BID, _volume)
  end

  def sync_ask_volume(_volume)
    sync_volume(Trader::Order::ASK, _volume)
  end

  private

  def load_core_account
    base_account = Trader.account account.exchange, account.parsed_credentials
    base_account.using pair
  end

  def create_order(_raw)
    order = decorate account.orders.new
    order.bind! _raw
    order
  end

  def decorate(_order)
    order = SyncOrder.new _order
    order.account = self # set inverse
    order
  end

  def unsynced_volume(_instruction)
    vol = account.orders.with_instruction(_instruction).unsynced.map do |order|
      decorate(order).unsynced_volume
    end.inject(pair.base.pack(0.0), :+)

    pair.base.pack vol
  end

  def sync_volume(_instruction, _volume)
    _volume = pair.base.pack(_volume)

    account.orders.with_instruction(_instruction).unsynced.order('id ASC').each do |order|
      break if _volume <= 0.0
      _volume = decorate(order).sync_volume _volume
    end

    pair.base.pack(_volume)
  end
end
