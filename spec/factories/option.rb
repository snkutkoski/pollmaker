FactoryGirl.define do
  factory :option do
    votes []
    name { Faker::Lorem.unique.sentence }
    poll
  end
end
