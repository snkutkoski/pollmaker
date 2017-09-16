FactoryGirl.define do
  factory :poll do
    question { Faker::Lorem.sentence }

    transient do
      option_count 4
    end

    after(:build) do |poll, evaluator|
      poll.options = build_list(:option, evaluator.option_count, poll: poll)
    end
  end
end
