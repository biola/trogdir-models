FactoryGirl.define do
  factory :address do
    type :home
    street_1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
    country { Faker::Address.country }
  end
end