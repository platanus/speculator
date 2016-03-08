FactoryGirl.define do
  factory :robot do
    name "The Name"
    engine "dummy"
    config nil
    last_execution_at nil
    delay 60.0
  end
end
