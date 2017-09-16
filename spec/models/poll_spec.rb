require 'rails_helper'

describe Poll do
  let(:poll) { build(:poll) }

  it 'Has a default valid factory' do
    expect(poll).to be_valid
  end

  it 'Is invalid without a question' do
    poll.question = ''
    expect(poll).not_to be_valid
  end

  it 'Is invalid with only one option' do
    poll.options = [build(:option, poll: poll)]
    expect(poll).not_to be_valid
  end

  it 'Is invalid if two options have the same name' do
    poll.options = build_list(:option, 2, name: 'Not unique name', poll: poll)
    expect(poll).not_to be_valid
  end
end
