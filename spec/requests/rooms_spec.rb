require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  describe 'GET /rooms' do
    context 'when not signed in' do
      it 'returns a 302 response' do
        get root_path
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        get root_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      let(:alice) { create :user }
      let!(:messages) { create_list(:message, 5) }

      before { sign_in alice }

      it 'returns a 200 response' do
        get root_path
        expect(response.status).to eq 200
      end

      it 'shows messages' do
        get root_path
        expect(response.body).to include messages.sample.content
      end
    end
  end
end
