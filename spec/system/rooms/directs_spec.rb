require 'rails_helper'

RSpec.describe 'Rooms::Directs', type: :system do
  let(:alice) { create :user }
  let!(:bob) { create :user }

  context 'when a room does not exist' do
    it 'creates a direct chat' do
      sign_in alice
      find('[data-rspec=move_to_users_index]').click
      expect do
        find("[data-rspec=create_direct_chat_with_#{bob.id}]").click
      end.to change(Entry, :count).by(2)
        .and change(Room, :count).by(1)
      slug = [alice, bob].map(&:id).sort.join('-')
      room = Room.find_by(slug: slug)
      expect(page).to have_current_path room_path(room)
    end
  end

  context 'when a room exists' do
    before do
      slug = [alice, bob].map(&:id).sort.join('-')
      room = create :room, slug: slug
      create :entry, room: room, user: alice
      create :entry, room: room, user: bob
    end

    it 'finds a direct chat' do
      sign_in alice
      find('[data-rspec=move_to_users_index]').click
      expect do
        find("[data-rspec=create_direct_chat_with_#{bob.id}]").click
      end.to change(Entry, :count).by(0)
        .and change(Room, :count).by(0)
      slug = [alice, bob].map(&:id).sort.join('-')
      room = Room.find_by(slug: slug)
      expect(page).to have_current_path room_path(room)
    end
  end
end
