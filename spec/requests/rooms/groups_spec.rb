require 'rails_helper'

RSpec.describe 'Rooms::Groups', type: :request do
  describe 'GET /rooms/groups/new' do
    let(:alice) { create :user }
    let!(:bob) { create :user }

    context 'when not signed in' do
      it 'returns a 302 response' do
        get new_rooms_group_path
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        get new_rooms_group_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when signed in' do
      before { sign_in alice }

      it 'returns a 200 response' do
        get new_rooms_group_path
        expect(response.status).to eq 200
      end

      it 'does not render current_user checkbox' do
        get new_rooms_group_path
        expect(response.body).not_to include "rooms_groups_new_checkbox_#{alice.id}"
      end

      it 'renders other user checkbox' do
        get new_rooms_group_path
        expect(response.body).to include "rooms_groups_new_checkbox_#{bob.id}"
      end
    end
  end

  describe 'POST /rooms/groups' do
    let(:alice) { create :user }
    let(:bob) { create :user }
    let(:carol) { create :user }
    let(:room_group_params) { { user_ids: [bob.id, carol.id] } }

    context 'when not signed in' do
      it 'returns a 302 response' do
        post rooms_groups_path, params: room_group_params
        expect(response.status).to eq 302
      end

      it 'redirects to new_user_session_path' do
        post rooms_groups_path, params: room_group_params
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not increase Entry count' do
        expect do
          post rooms_groups_path, params: room_group_params
        end.to change(Entry, :count).by(0)
      end

      it 'does not increase Room count' do
        expect do
          post rooms_groups_path, params: room_group_params
        end.to change(Room, :count).by(0)
      end
    end

    context 'when signed in and room_group_params is nil' do
      let(:room_direct_params_with_nil) { { user_ids: [] } }

      before { sign_in alice }

      it 'returns a 200 response' do
        post rooms_groups_path, params: room_direct_params_with_nil
        expect(response.status).to eq 200
      end

      it 'has correct flash message' do
        post rooms_groups_path, params: room_direct_params_with_nil
        expect(flash[:alert]).to eq '入力に問題があります。'
      end

      it 'does not increase Entry count' do
        expect do
          post rooms_groups_path, params: room_direct_params_with_nil
        end.to change(Entry, :count).by(0)
      end

      it 'does not increase Room count' do
        expect do
          post rooms_groups_path, params: room_direct_params_with_nil
        end.to change(Room, :count).by(0)
      end
    end

    context 'when signed in and room_group_params is nonexistent' do
      let(:room_direct_params_with_nonexistent) { { user_ids: [0] } }

      before { sign_in alice }

      it 'returns a 200 response' do
        post rooms_groups_path, params: room_direct_params_with_nonexistent
        expect(response.status).to eq 200
      end

      it 'has correct flash message' do
        post rooms_groups_path, params: room_direct_params_with_nonexistent
        expect(flash[:alert]).to eq '入力に問題があります。'
      end

      it 'does not increase Entry count' do
        expect do
          post rooms_groups_path, params: room_direct_params_with_nonexistent
        end.to change(Entry, :count).by(0)
      end

      it 'does not increase Room count' do
        expect do
          post rooms_groups_path, params: room_direct_params_with_nonexistent
        end.to change(Room, :count).by(0)
      end
    end

    context 'when signed in and room_group_params is self' do
      let(:room_direct_params_with_self) { { user_ids: [alice.id] } }

      before { sign_in alice }

      it 'returns a 200 response' do
        post rooms_groups_path, params: room_direct_params_with_self
        expect(response.status).to eq 200
      end

      it 'has correct flash message' do
        post rooms_groups_path, params: room_direct_params_with_self
        expect(flash[:alert]).to eq 'この操作は実行できません。'
      end

      it 'does not increase Entry count' do
        expect do
          post rooms_groups_path, params: room_direct_params_with_self
        end.to change(Entry, :count).by(0)
      end

      it 'does not increase Room count' do
        expect do
          post rooms_groups_path, params: room_direct_params_with_self
        end.to change(Room, :count).by(0)
      end
    end

    context 'when signed in and room_group_params is valid' do
      before { sign_in alice }

      it 'returns a 302 response' do
        post rooms_groups_path, params: room_group_params
        expect(response.status).to eq 302
      end

      it 'redirects to room_path' do
        post rooms_groups_path, params: room_group_params
        room = Room.find_by(name: [alice, bob, carol].map(&:name).sort.join(', '))
        expect(response).to redirect_to room_path(room)
      end

      it 'increases Entry count' do
        expect do
          post rooms_groups_path, params: room_group_params
        end.to change(Entry, :count).by(3)
          .and change { alice.entries.count }.by(1)
          .and change { bob.entries.count }.by(1)
          .and change { carol.entries.count }.by(1)
      end

      it 'increases Room count' do
        expect do
          post rooms_groups_path, params: room_group_params
        end.to change(Room, :count).by(1)
          .and change { alice.rooms.count }.by(1)
          .and change { bob.rooms.count }.by(1)
          .and change { carol.rooms.count }.by(1)
      end
    end
  end
end
