require 'rails_helper'

describe Option do
  let(:option) { build(:option) }

  it 'Has a valid factory' do
    expect(option).to be_valid
  end

  it 'Is invalid without a vote count' do
    option.vote_count = nil
    expect(option).not_to be_valid
  end

  it 'Is invalid without a name' do
    option.name = ''
    expect(option).not_to be_valid
  end

  it 'Is invalid if the name is not unique within its poll' do
    poll = create(:poll)
    option.name = poll.options.first.name
    option.poll = poll
    expect(option).not_to be_valid
  end

  it 'Is valid if the name is not unique across different polls' do
    poll = create(:poll)
    option.name = poll.options.first.name
    expect(option).to be_valid
  end
end
