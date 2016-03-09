class LinearOrderGenerator < Struct.new(:instruction, :spread, :step)

  def generate(_start_price, _volume)
    buckets = (spread / step).floor
    volume = (_volume / buckets).floor

    buckets.times.map do |i|
      price = _start_price + step * multiplier * i
      [volume, price]
    end
  end

  def multiplier
    @multiplier ||= (instruction == :bid ? -1 : 1)
  end

end
