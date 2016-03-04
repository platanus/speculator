require 'forwardable'

class SyncAccount
  extend Forwardable

  attr_reader :account

  def_delegators :core_account, :base_balance, :quote_balance

  def initialize(_account)
    @account = _account
  end

  def pair
    @pair ||= Trader::CurrencyPair.for_code(account.base_currency.to_sym, account.quote_currency.to_sym)
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

  private

  def load_core_account
    base_account = Trader.account account.exchange, account.parsed_credentials
    base_account.using pair
  end

  def create_order(_raw)
    order = SyncOrder.new account.orders.new, _raw
    order.save!
    order
  end
end
