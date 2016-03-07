class OrderPool

  DEF_PRICE_THR = 0.01
  DEF_VOLUME_THR = 0.01

  attr_reader :account, :instruction, :orders, :price_thr, :volume_thr

  def initialize(_account, _instruction, _options={})
    raise ArgumentError, "invalid instruction #{_instruction}" unless [:bid, :ask].include? _instruction

    @account = _account
    @instruction = _instruction
    @orders = []

    @price_thr = _options.fetch(:price_thr, DEF_PRICE_THR)
    @volume_thr = _options.fetch(:volume_thr, DEF_VOLUME_THR)
  end

  def refresh_orders
    @orders = account.orders(instruction: instruction, open: true)
    @orders.each(&:refresh!)
    @orders = @orders.select(&:open?)
  end

  def sync(_new_orders, _options={})
    refresh_orders
    _new_orders = process_new_orders _new_orders
    _new_orders = merge_orders _new_orders
    open_orders _new_orders, available_balance
  end

  def cancel_all
    # IDEA: mark accounts as 'exclusive', that way we can use bulk methods like cancel all
    @orders.each(&:cancel!)
  end

  private

  def pair
    account.pair
  end

  def process_new_orders(_orders)
    _orders.map do |order|
      raise ArgumentError, "invalid order type" if invalid_order? order
      order.convert_to pair
    end
  end

  def invalid_order?(_order)
    _order.type != instruction
  end

  def merge_orders(_orders)
    sorted_orders.each do |current_order|
      non_matched_volume = current_order.pending_volume

      new_orders = _orders.inject([]) do |r, order|
        if non_matched_volume > 0.0 and order_matches? order, current_order
          if order.volume > non_matched_volume
            new_order_volume = order.volume - non_matched_volume
            non_matched_volume = non_matched_volume.currency.pack 0.0
            next r if new_order_volume / order.volume < volume_thr
            order.volume = new_order_volume
          else
            non_matched_volume -= order.volume
            next r # skip order, its already covered
          end
        end

        r << order
      end

      if non_matched_volume / current_order.pending_volume > volume_thr
        # puts "No enough matches (#{non_matched_volume}), discarding!"
        current_order.cancel!
      else
        # puts "Matched!, new orders: #{new_orders}"
        _orders = new_orders
      end
    end

    _orders
  end

  def sorted_orders
    if instruction == Trader::Order::TYPE_ASK
      orders.sort_by { |p| p.price.amount }
    else
      orders.sort_by { |p| p.price.amount * -1 }
    end
  end

  def order_matches?(_order, _current_order)
    variation = _order.price.amount - _current_order.price.amount
    variation = variation / _current_order.price.amount
    variation.abs < price_thr
  end

  def open_orders(_raw_orders, _limit)
    _limit = _limit.amount

    _raw_orders.each do |order|
      break if _limit <= 0.0

      if instruction == Trader::Order::TYPE_ASK
        order.volume = order.volume.currency.pack([_limit, order.volume.amount].min)
        _limit -= order.volume.amount
      else
        volume_limit = _limit / order.price.amount
        order.volume = order.volume.currency.pack([volume_limit, order.volume.amount].min)
        _limit -= order.volume * order.price.amount
      end

      create_order order
    end
  end

  def create_order(_raw_order)
    @orders << account.public_send(instruction, _raw_order.volume, _raw_order.price)
  end

  def available_balance
    # TODO: allow configuration of limit
    if instruction == Trader::Order::TYPE_ASK
      account.base_balance.available_amount
    else
      account.quote_balance.available_amount
    end
  end
end
