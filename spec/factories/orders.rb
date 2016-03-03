FactoryGirl.define do
  factory :order do
    account
    ex_id 10
    price 50_000
    volume 1.0
    instruction :bid
    base_currency 'BTC'
    quote_currency 'CLP'
  end
end
