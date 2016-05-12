module CustomExtensions
  module Account
    def replace_bids_in(_account, _options = {})
      order_pairs = build_orders(_options.fetch(:use), _account.pair, Trader::Order::BID)
      OrderPool.new(_account, Trader::Order::BID, _options.merge(logger: logger)).sync order_pairs
    end

    def replace_asks_in(_account, _options = {})
      order_pairs = build_orders(_options.fetch(:use), _account.pair, Trader::Order::ASK)
      OrderPool.new(_account, Trader::Order::ASK, _options.merge(logger: logger)).sync order_pairs
    end

    private

    def build_orders(_raw_orders, _pair, _instruction)
      _raw_orders.map do |volume, price|
        volume = _pair.base.unpack volume
        price = _pair.quote.unpack price
        Trader::Order.new _pair, _instruction, volume, price
      end
    end
  end
end
