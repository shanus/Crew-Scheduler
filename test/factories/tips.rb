# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tip do
    content "MyText"
    path "MyString"
    creator_id 1
    modifier_id 1
  end
end
