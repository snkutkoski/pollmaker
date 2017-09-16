require 'rails_helper'

describe 'Polls requests', type: :request do
  describe 'POST /polls' do
    let(:headers) {{'ACCEPT': 'application/json', 'CONTENT_TYPE': 'application/json'}}
    let(:question) { 'What kind of bear is best?' }
    let(:option_names) { ['Black bear', 'Brown bear'] }
    let(:params) { {poll: {question: question, options: option_names.map { |n| {name: n} }}} }

    subject { post '/polls', params: params.to_json, headers: headers }

    it 'Responds with the created poll as json' do
      subject

      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(201)

      hash = JSON.parse(response.body).with_indifferent_access

      expect(hash[:question]).to eq(question)
      expect(hash[:options].map { |o| o[:name] }).to contain_exactly(*option_names)
    end

    it 'Creates a new poll with options' do
      polls_before = Poll.count
      options_before = Option.count

      subject

      expect(Poll.count).to eq(polls_before + 1)
      expect(Option.count).to eq(options_before + 2)
    end

    context 'invalid params' do
      let(:question) { '' }

      it 'Responds with errors and 422 status code' do
        subject

        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status 422

        hash = JSON.parse(response.body).with_indifferent_access

        expect(hash[:errors]).to be_present
      end

      it 'Does not save any polls or options' do
        polls_before = Poll.count
        options_before = Option.count

        subject

        expect(Poll.count).to eq(polls_before)
        expect(Option.count).to eq(options_before)
      end
    end
  end

  describe 'GET /polls/:id' do
    let(:headers) {{'ACCEPT': 'application/json'}}
    let(:poll) { create(:poll) }

    subject { get "/polls/#{poll.id}", headers: headers }

    it 'Returns the found poll as json' do
      subject

      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(200)

      hash = JSON.parse(response.body).with_indifferent_access

      expect(hash[:question]).to eq(poll.question)
      expect(hash[:options].map { |o| o[:name] }).to contain_exactly(*(poll.options.map(&:name)))
    end

    it 'Responds with a 404 status if the poll is not found' do
      allow(PollsService).to receive(:find).and_return(nil)

      subject

      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(404)
    end
  end
end
