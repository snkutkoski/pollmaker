require 'rails_helper'

describe 'Options requests' do
  describe 'POST /options/:id/vote' do
    let(:headers) { {'ACCEPT': 'application/json'} }

    let(:poll) { create(:poll) }
    let(:option) { poll.options.first }

    subject { post "/options/#{option.id}/vote", headers: headers }

    it 'Adds to the vote count' do
      count_before = option.votes.count
      subject
      expect(option.reload.votes.count).to eq(count_before + 1)
    end

    it 'Responds with 200 status code' do
      post "/options/#{option.id}/vote", headers: headers
      subject
      expect(response).to have_http_status 200
    end
  end
end
