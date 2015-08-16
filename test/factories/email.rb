FactoryGirl.define do
  factory :email do
    subject "My TestProject"
    text_part "Tests for project"
    from { Faker::Internet.email }
    to { Faker::Internet.email }
    date
  end
end