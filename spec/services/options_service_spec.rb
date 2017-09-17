require 'rails_helper'

describe OptionsService do
  describe '.vote' do
    it 'Increases the vote count by 1' do
      option = create(:option)
      count_before = option.votes.count
      OptionsService.vote(option.id)
      expect(option.reload.votes.count).to eq(count_before + 1)
    end
  end
end
