# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    starts_at "2012-11-15 08:18:16"
    ends_at "2012-11-15 08:18:16"
    team_id 1
    boat_id 1
  end
end
