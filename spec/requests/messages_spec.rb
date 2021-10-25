require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  describe 'POST /messages' do
    let(:message_params) { { message: { content: 'メッセージ' } } }

    context 'when not signed in' do
      it 'returns a 302 response' do
        post messages_path, params: message_params
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        post messages_path, params: message_params
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Message count' do
        expect do
          post messages_path, params: message_params
        end.to change(Message, :count).by(0)
      end
    end

    context 'when signed in' do
      let(:alice) { create :user }

      before { sign_in alice }

      it 'returns a 200 response' do
        post messages_path, params: message_params
        expect(response.status).to eq 200
      end

      it 'increases Message count' do
        expect do
          post messages_path, params: message_params
        end.to change(Message, :count).by(1)
          .and change { alice.messages.count }.by(1)
      end
    end
  end
end
