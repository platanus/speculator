[:CLP, :USD, :BTC].each do |curr|
  define_method(curr.to_s.downcase) do |_value=nil|
    return Trader::Currency.for_code(curr) if _value.nil?
    Trader::Price.new(curr, _value)
  end
end
