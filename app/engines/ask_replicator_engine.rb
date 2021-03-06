require "trade-o-matic/support/converter_configurator"

class AskReplicatorEngine < BaseEngine

  attr_reader :delay, :margin, :skip_volume_time, :min_balance, :min_sync_volume

  def unpack_config(_config)
    base_currency = _config['base'] || 'BTC'
    # TODO: Check that both target and source use the same base currency!

    @delay = _config['delay']
    @margin = _config['margin'] || 0.0
    @skip_volume_time = _config['skip_volume_time'] || (@delay * 2)
    @min_balance = _config['min_balance'] || 0.0
    @min_sync_volume = _config['min_sync_volume'] || 0.0

    load_generator _config['generator']
    load_pool _config
  end

  def perform
    log "Starting Ask Replicator V0.1 (#{source.pair} - #{target.pair})"
    log "-"

    validate_rate

    skip_volume = source_market.volume skip_volume_time # last N seconds volume
    start_price = source_market.ask_slope.price skip_volume
    start_price = start_price * (1.0 + margin)

    log "skipping #{skip_volume}, starting price #{start_price.convert_to(target.pair.quote)}"

    source_quote_balance = source.quote_balance
    target_base_balance = target.base_balance

    log "current source balance: #{source_quote_balance.amount}"
    log "current target balance: #{target_base_balance.amount}"

    available_volume = source_market.ask_slope.assess source_quote_balance.amount, skip_volume
    available_volume = target_base_balance.amount if target_base_balance.amount < available_volume

    log "available volume: #{available_volume}"

    if available_volume <= min_sync_volume
      log "Ouch!, balance is too low!"
      return []
    end

    new_orders = generate start_price, available_volume
    # TODO: new_orders = adjust_orders_to_slope new_orders, source_market.ask_slope

    log "Generated orders:"
    new_orders.each_with_index do |order, idx|
      log "- ask ##{idx}: #{order.volume} at #{order.price}"
    end

    pool.sync new_orders

    if target.unsynced_volume > min_sync_volume
      log "Executing #{target.unsynced_volume}"
      # source.bid target.unsynced_volume, start_price
      # target.sync_volume
    else
      log 'No orders where executed during last iteration'
    end

    stat :balance, every: 1.hour do
      total_base_amount = target.base_balance.amount + source.base_balance.amount
      local_balance = target.quote_balance.amount
      local_balance += source_market.ask_slope.quote(total_base_amount, skip_volume)
      local_balance += source.quote_balance.amount
      log "Calculated total balance: #{local_balance}"
      local_balance.amount
    end
  end

private

  attr_reader :generator, :pool

  def log(_message)
    logger.info(_message)
  end

  def source
    @source ||= get_account :source
  end

  def target
    @target ||= get_account :target
  end

  def source_market
    @source_market ||= source.market
  end

  def load_pool(_config)
    @pool = OrderPool.new(target, :ask, {
      price_thr: _config['pool_price_thr'] || 0.01,
      volume_thr: _config['pool_volume_thr'] || 0.01,
      min_order_volume: target.pair.base.pack(_config['pool_min_volume'] || 0.0),
      logger: logger
    })
  end

  def load_generator(_config)
    @generator = case (_config['type'] || 'linear')
    when 'linear'
      LinearOrderGenerator.new :ask, _config['spread'], _config['step']
    else
      raise "Invalid generator #{_config['type']}"
    end
  end

  def validate_rate
    rate = Trader::Currency.converter_for!(source.pair.quote, target.pair.quote).rate
    if rate < 650 || rate > 750
      raise "CLP/USD exchange rate out of range! (#{rate})"
    end

    log "Current #{target.pair.quote}/#{source.pair.quote} rate: #{rate}"
  end

  def generate(_start_price, _volume)
    raw = generator.generate _start_price.convert_to(target.pair.quote), _volume.amount
    raw.map { |p| Trader::Order.new_ask(target.pair, p[0], p[1]) }
  end
end
