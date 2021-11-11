require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  describe 'POST /messages' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:room) do
      carol = create :user
      room = create :room
      create :entry, room: room, user: alice
      create :entry, room: room, user: carol
      room
    end
    let(:message_params) { { message: attributes_for(:message) } }

    context 'when not signed in' do
      it 'returns a 401 response' do
        post room_messages_path(room), params: message_params, xhr: true
        expect(response.status).to eq 401
      end

      it 'does not increase Message count' do
        expect do
          post room_messages_path(room), params: message_params, xhr: true
        end.to change(Message, :count).by(0)
      end
    end

    context 'when signed in as unauthorized user' do
      before { sign_in bob }

      it 'raises Pundit::NotAuthorizedError' do
        expect do
          post room_messages_path(room), params: message_params, xhr: true
        end.to raise_error(Pundit::NotAuthorizedError)
      end

      it 'does not increase Message count' do
        expect do
          post room_messages_path(room), params: message_params, xhr: true
        end.to raise_error(Pundit::NotAuthorizedError)
        expect(Message.count).to eq 0
      end
    end

    context 'when signed in as authorized user' do
      before { sign_in alice }

      it 'returns a 200 response' do
        post room_messages_path(room), params: message_params, xhr: true
        expect(response.status).to eq 200
      end

      it 'increases Message count' do
        expect do
          post room_messages_path(room), params: message_params, xhr: true
        end.to change(Message, :count).by(1)
          .and change(alice.messages, :count).by(1)
          .and change(room.messages, :count).by(1)
      end
    end
  end
end
