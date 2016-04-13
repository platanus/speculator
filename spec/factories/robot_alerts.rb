FactoryGirl.define do
  factory :robot_alert do
    robot nil
    message "MyText"
    last_triggered_at "2016-04-13 17:01:10"
    triggered_at "2016-04-13 17:01:10"
  end
end
