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

    context 'when signed in and entry_params is self' do
      let(:self_entry_params) { { user_id: alice.id } }

      before { sign_in alice }

      it 'returns a 302 response' do
        post entries_path, params: self_entry_params
        expect(response.status).to eq 302
      end

      it 'redirects to request.referer || root_path' do
        post entries_path, params: self_entry_params
        expect(response).to redirect_to(request.referer || root_path)
      end

      it 'does not increase Entry count' do
        expect do
          post entries_path, params: self_entry_params
        end.to change(Entry, :count).by(0)
          .and change { alice.entries.count }.by(0)
      end

      it 'does not increase Room count' do
        expect do
          post entries_path, params: self_entry_params
        end.to change(Room, :count).by(0)
          .and change { alice.rooms.count }.by(0)
      end
    end

    context 'when signed in and entry_params is other_user, room exists' do
      before do
        slug = [alice, bob].map(&:id).sort.join('-')
        room = create :room, slug: slug, room_type: 'direct'
        create :entry, room: room, user: alice
        create :entry, room: room, user: bob
        sign_in alice
      end

      it 'returns a 302 response' do
        post entries_path, params: entry_params
        expect(response.status).to eq 302
      end

      it 'redirects to room_path' do
        post entries_path, params: entry_params
        slug = [alice, bob].map(&:id).sort.join('-')
        room = Room.find_by(slug: slug)
        expect(response).to redirect_to room_path(room)
      end

      it 'does not increase Entry count' do
        expect do
          post entries_path, params: entry_params
        end.to change(Entry, :count).by(0)
          .and change { alice.entries.count }.by(0)
          .and change { bob.entries.count }.by(0)
      end

      it 'does not increase Room count' do
        expect do
          post entries_path, params: entry_params
        end.to change(Room, :count).by(0)
          .and change { alice.rooms.count }.by(0)
          .and change { bob.rooms.count }.by(0)
      end
    end

    context 'when signed in and entry_params is other_user, room does not exist' do
      before { sign_in alice }

      it 'returns a 302 response' do
        post entries_path, params: entry_params
        expect(response.status).to eq 302
      end

      it 'redirects to room_path' do
        post entries_path, params: entry_params
        slug = [alice, bob].map(&:id).sort.join('-')
        room = Room.find_by(slug: slug)
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
