FactoryGirl.define do
  factory :id, class: ID do
    type { :netid }
    person
    identifier { Faker::Internet.user_name }
  end
end