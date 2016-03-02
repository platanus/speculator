FactoryGirl.define do
  factory :order do
    account
    ex_id nil
    price 50_000
    volume 1.0
    instruction :bid
  end
end
