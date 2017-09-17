require 'rails_helper'

describe Vote do
  describe '.vote_counts' do
    it 'Returns a hash of option_id => number_of_votes' do
      poll = create(:poll, option_count: 4)

      option1 = poll.options[0]
      Vote.create(option: option1)

      option2 = poll.options[1]
      Vote.create(option: option2)
      Vote.create(option: option2)

      option3 = poll.options[2]
      Vote.create(option: option3)
      Vote.create(option: option3)
      Vote.create(option: option3)

      option4 = poll.options[3]

      counts = Vote.vote_counts(poll.options)

      expected_hash = {
        option1.id => 1,
        option2.id => 2,
        option3.id => 3,
        option4.id => 0
      }

      expect(counts).to eq(expected_hash)
    end
  end
end
