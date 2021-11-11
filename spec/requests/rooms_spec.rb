require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  describe 'GET /rooms' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:room) do
      carol = create :user
      room = create :room
      create :entry, room: room, user: alice
      create :entry, room: room, user: carol
      room
    end

    context 'when not signed in' do
      it 'returns a 302 response' do
        get rooms_path
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        get rooms_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in as unauthorized user' do
      before { sign_in bob }

      it 'returns a 200 response' do
        get rooms_path
        expect(response.status).to eq 200
      end

      it 'does not render the other user room name' do
        get rooms_path
        expect(response.body).not_to include room.name
      end
    end

    context 'when signed in as authorized user' do
      before { sign_in alice }

      it 'returns a 200 response' do
        get rooms_path
        expect(response.status).to eq 200
      end

      it 'renders a room name' do
        get rooms_path
        expect(response.body).to include room.name
      end
    end
  end

  describe 'GET /room/:id' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let!(:room) do
      carol = create :user
      room = create :room
      create :entry, room: room, user: alice
      create :entry, room: room, user: carol
      room
    end

    context 'when not signed in' do
      it 'returns a 302 response' do
        get room_path(room)
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        get room_path(room)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in as unauthorized user' do
      before { sign_in bob }

      it 'raises Pundit::NotAuthorizedError' do
        expect do
          get room_path(room)
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when signed in as authorized user' do
      before { sign_in alice }

      it 'returns a 200 response' do
        get room_path(room)
        expect(response.status).to eq 200
      end

      it 'renders a room name' do
        get room_path(room)
        expect(response.body).to include room.name
      end
    end
  end
end
