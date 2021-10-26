require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  describe 'POST /entries' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:entry_params) { { user_id: bob.id } }

    context 'when not signed in' do
      it 'returns a 302 response' do
        post entries_path, params: entry_params
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        post entries_path, params: entry_params
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Entry count' do
        expect do
          post entries_path, params: entry_params
        end.to change(Entry, :count).by(0)
      end

      it 'does not increase Room count' do
        expect do
          post entries_path, params: entry_params
        end.to change(Room, :count).by(0)
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns a 302 response' do
        post entries_path, params: entry_params
        expect(response.status).to eq 302
      end

      it 'redirects to room_path' do
        post entries_path, params: entry_params
        alice_room_ids = alice.room_ids
        bob_room_ids = bob.room_ids
        room = Room.find(alice_room_ids & bob_room_ids)
        expect(response).to redirect_to room_path(room)
      end

      it 'increases Entry count' do
        expect do
          post entries_path, params: entry_params
        end.to change(Entry, :count).by(2)
          .and change { alice.entries.count }.by(1)
          .and change { bob.entries.count }.by(1)
      end

      it 'increases Room count' do
        expect do
          post entries_path, params: entry_params
        end.to change(Room, :count).by(1)
          .and change { alice.rooms.count }.by(1)
          .and change { bob.rooms.count }.by(1)
      end
    end
  end
end
