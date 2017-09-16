FactoryGirl.define do
  factory :option do
    vote_count 0
    name { Faker::Lorem.unique.sentence }
    poll
  end
end
