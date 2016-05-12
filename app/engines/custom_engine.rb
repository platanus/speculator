class CustomEngine < BaseEngine
  def self.config_lang
    'ruby'
  end

  include Cleanroom
  include CustomExtensions::Account

  def info(_msg)
    logger.info(_msg)
  end

  # Exposed engine methods
  expose :get_account
  expose :get_accounts
  expose :logger
  expose :info
  expose :log_exception
  expose :stat
  expose :alert
  expose :end_alert
  expose :replace_bids_in
  expose :replace_asks_in

  private

  def load_configuration(_raw)
    _raw
  end

  def dump_configuration(_raw)
    _raw
  end

  def generate_default_configuration
    "
    # Write some ruby code here
    #
    # Available methods: ...
    #
    "
  end

  def validate_configuration(_config)
    # TODO: use a ruby linter to validate
    true
  end

  def perform_with_configuration(_config)
    evaluate _config
  end
end
