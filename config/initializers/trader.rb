if Rails.env.development?
  Trader.setup_game_backend do |config|
    config.db_file = Rails.root.join 'tmp/game_exchange.yml'

    config.setup_market :BTC, :CLP
    config.setup_market :BTC, :USD
  end
end
