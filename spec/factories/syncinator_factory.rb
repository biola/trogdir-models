FactoryGirl.define do
  factory :syncinator do
    name { Faker::Company.catch_phrase }
    queue_changes true
    active true
  end
end