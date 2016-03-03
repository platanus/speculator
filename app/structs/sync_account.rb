require 'forwardable'

class SyncAccount
  extend Forwardable

  attr_reader :account

  def initialize(_account)
    @account = _account
  end

  def pair
    @pair ||= Trader::CurrencyPair.for_code(account.base_currency.to_sym, account.quote_currency.to_sym)
  end

  def core_account
    @core ||= load_core_account
  end

  def_delegators :core_account, :base_balance, :quote_balance

  private

  def load_core_account
    base_account = Trader.account account.exchange, account.parsed_credentials
    base_account.using pair
  end
end
