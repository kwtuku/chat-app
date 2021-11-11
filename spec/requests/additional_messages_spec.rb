require 'rails_helper'

RSpec.describe 'AdditionalMessages', type: :request do
  describe 'GET /rooms/:room_id/additional_messages' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:room) do
      carol = create :user
      room = create :room
      create :entry, room: room, user: alice
      create :entry, room: room, user: carol
      room
    end
    let(:messages) { alice.messages.order(id: :DESC) }

    before { create_list :message, 101, room: room, user: alice }

    context 'when not signed in' do
      it 'returns a 401 response' do
        get room_additional_messages_path(room, message_count: 50), xhr: true
        expect(response.status).to eq 401
      end
    end

    context 'when signed in as unauthorized user' do
      before { sign_in bob }

      it 'raises Pundit::NotAuthorizedError' do
        expect do
          get room_additional_messages_path(room, message_count: 50), xhr: true
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when signed in as authorized user' do
      before { sign_in alice }

      it 'returns a 200 response' do
        get room_additional_messages_path(room, message_count: 50), xhr: true
        expect(response.status).to eq 200
      end

      it 'renders correct messages' do
        get room_additional_messages_path(room, message_count: 50), xhr: true
        expect(response.body).not_to include "message_#{messages[49].id}"
        expect(response.body).to include "message_#{messages[50].id}"
        expect(response.body).to include "message_#{messages[99].id}"
        expect(response.body).not_to include "message_#{messages[100].id}"
      end
    end
  end
end
