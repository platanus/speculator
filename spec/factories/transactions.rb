FactoryGirl.define do
  factory :transaction do
    account
    timestamp "2016-06-01 17:15:43"
    price 1.5
    volume 1.5
    instruction 1
  end
end
