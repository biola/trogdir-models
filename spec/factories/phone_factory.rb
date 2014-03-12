FactoryGirl.define do
  factory :phone do
    type :office
    number { Faker::PhoneNumber.phone_number }
  end
end