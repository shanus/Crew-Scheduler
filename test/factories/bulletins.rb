# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bulletin do
    title "MyString"
    content "MyText"
    display_until "2012-11-15 09:16:40"
    creator_id 1
  end
end
