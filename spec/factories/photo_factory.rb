FactoryGirl.define do
  factory :photo do
    type :id_card
    url { Faker::Internet.url }
    height 100
    width 100
  end
end