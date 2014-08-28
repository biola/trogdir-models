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
    groups []
    enabled true

    trait :student do
      residence 'The Stick'
      floor 1
      wing 'West'
      majors ['Mousepad Engineer']
      privacy false
    end

    trait :employee do
      department 'Cracking Wise'
      title 'Guy With a Big Knife'
      employee_type :'Full-Time'
      full_time true
      pay_type :'02'
    end
  end
end
