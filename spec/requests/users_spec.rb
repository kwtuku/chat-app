require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users' do
    context 'when not signed in' do
      it 'returns a 302 response' do
        get users_path
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        get users_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      let(:alice) { create :user }
      let!(:bob) { create :user }

      before { sign_in alice }

      it 'returns a 200 response' do
        get users_path
        expect(response.status).to eq 200
      end

      it 'renders a user' do
        get users_path
        expect(response.body).to include "create_direct_chat_with_#{bob.id}"
      end

      it 'does not render the current user' do
        get users_path
        expect(response.body).not_to include "create_direct_chat_with_#{alice.id}"
      end
    end
  end
end
