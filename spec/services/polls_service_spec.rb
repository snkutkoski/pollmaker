require 'rails_helper'

describe PollsService do
  describe PollsService::Poll do
    describe '.from_record' do
      it 'Returns a Poll with the same question and options as the record' do
        record = build(:poll)
        poll = PollsService::Poll.from_record(record)
        expect(poll.question).to eq(record.question)
        poll.options.each_with_index do |option, i|
          expect(option.name).to eq(record.options[i].name)
        end
      end
    end

    describe '#valid?' do
      it 'Is invalid if it has errors' do
        poll = PollsService::Poll.new(Faker::Lorem.sentence, [], 1, {question: 'cannot be blank'})
        expect(poll).not_to be_valid
      end

      it 'Is invalid if one of its options has errors' do
        options = [OptionsService::Option.new(Faker::Lorem.sentence, 100, 1, {}),
                   OptionsService::Option.new(Faker::Lorem.sentence, 100, 2, {name: 'cannot be blank'})]
        poll = PollsService::Poll.new(Faker::Lorem.sentence, options, 1, {})
        expect(poll).not_to be_valid
      end
    end
  end

  describe '.create' do
    let(:question) { Faker::Lorem.sentence }
    let(:options) do
      (1..3).map { |_| {name: Faker::Lorem.sentence} }
    end
    let(:params) { {question: question, options: options} }

    before do
      allow(Poll).to receive(:create).and_return(
          build(:poll, question: question, options: options.map { |o| Option.new(o) }))
    end

    it 'Returns a PollsService::Poll with the given question and options' do
      poll = PollsService.create(params)
      expect(poll.question).to eq(question)
      expect(poll.options.map(&:name)).to contain_exactly(*(options.map { |o| o[:name] }))
    end

    it 'Saves the Poll' do
      expect(Poll).to receive(:create)
      PollsService.create(params)
    end
  end

  describe '.find' do
    let(:id) { 1 }
    let(:record) { build(:poll) }

    it 'Returns the found poll' do
      allow(Poll).to receive(:find).with(id).and_return(record)

      poll = PollsService.find(id)
      expect(poll).to be_a PollsService::Poll
      expect(poll.question).to eq(record.question)
    end

    it 'Returns nil if no poll is found' do
      allow(Poll).to receive(:find).with(id).and_raise(ActiveRecord::RecordNotFound)

      poll = PollsService.find(id)
      expect(poll).to be_nil
    end
  end
end
