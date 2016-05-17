FactoryGirl.define do
  factory :account do
    robot
    name "Fake"
    base_currency 'BTC'
    quote_currency 'CLP'
    exchange "fake"
    credentials "base: BTC\nquote: CLP\nbase_balance: 10.0\nquote_balance: 10000000.0\nmarket_price: 300000.0"
  end
end
