module CustomExtensions
  module Money
    CURRENCIES = ['CLP', 'USD', 'BTC']

    CURRENCIES.each do |curr|
      define_method(curr.downcase) do |_value=nil|
        return Trader::Currency.for_code(curr) if _value.nil?
        Trader::Price.new(curr, _value)
      end
    end

    def self.included(_class)
      CURRENCIES.each { |curr| _class.expose curr.downcase.to_sym }
    end
  end
end
