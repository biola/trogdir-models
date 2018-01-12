FactoryGirl.define do
  factory :guest_account do
    person
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.free_email }
    password { Faker::Internet.password(12) }
  end
end
