FactoryGirl.define do
  factory :person do
    first_name { Faker::Name.first_name }
    preferred_name { first_name }
    last_name { Faker::Name.last_name }
    display_name { "#{first_name} #{last_name}"}
    gender { [:male, :female].sample }
    partial_ssn { 1234 }
    birth_date { 20.years.ago }
    entitlements []
    affiliations []
    privacy false
    enabled true
  end
end