FactoryGirl.define do
  factory :poll do
    question { Faker::Lorem.sentence }

    transient do
      options nil
      option_count 4
    end

    after(:build) do |poll, evaluator|
      if evaluator.options
        poll.options = evaluator.options
      else
        poll.options = build_list(:option, evaluator.option_count, poll: poll)
      end
    end
  end
end
