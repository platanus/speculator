class BaseEngine

  attr_reader :config

  def initialize(_accounts, _config)
    @accounts = _accounts.map { |a| SyncAccount.new a }
    @config = _config
  end

  def get_account(_name=nil)
    picks = get_accounts(_name)
    raise ArgumentError, "No account found for name #{_name}" if picks.count == 0
    raise ArgumentError, "More than one account is available as #{_name}" if picks.count > 1
    picks.first
  end

  def get_accounts(_name=nil)
    return @accounts.clone if _name.nil?
    @accounts.select { |a| a.name == _name.to_s }
  end

  def prepare
    unpack_config config
  end

  def tick
    Trader::Currency.isolate_conversions { perform }
  end

  # TODO: provide alert generation methods to engines

  # Abstract methods:

  def unpack_config(_config)
    raise NotImplementedError, '`unpack_config` method not implemented'
  end

  def perform
    raise NotImplementedError, '`perform` method not implemented'
  end
end
