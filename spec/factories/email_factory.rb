FactoryGirl.define do
  factory :email do
    type :university
    address { Faker::Internet.email }
    primary false
  end
end