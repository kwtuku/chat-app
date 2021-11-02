require 'rails_helper'

RSpec.describe 'Rooms::Groups', type: :system do
  describe '#new' do
    let(:alice) { create :user }

    it 'does not show current_user checkbox' do
      sign_in alice
      find('[data-rspec=move_to_rooms_groups_new]').click
      expect(page).not_to have_selector("[data-rspec=rooms_groups_new_checkbox_#{alice.id}]")
    end
  end

  describe '#create' do
    let(:alice) { create :user }
    let!(:bob) { create :user }
    let!(:carol) { create :user }

    context 'when user does not select other users' do
      it 'does not create a group chat' do
        sign_in alice
        find('[data-rspec=move_to_rooms_groups_new]').click
        expect do
          find('[data-rspec=create_group_chat]').click
        end.to change(Entry, :count).by(0)
          .and change(Room, :count).by(0)
        expect(page).to have_selector('[data-rspec=flash_message]', text: '入力に問題があります。')
      end
    end

    context 'when user selects other users' do
      it 'creates a group chat' do
        sign_in alice
        find('[data-rspec=move_to_rooms_groups_new]').click
        find("[data-rspec=rooms_groups_new_checkbox_#{bob.id}]").check
        find("[data-rspec=rooms_groups_new_checkbox_#{carol.id}]").check
        expect do
          find('[data-rspec=create_group_chat]').click
        end.to change(Entry, :count).by(3)
          .and change(Room, :count).by(1)
      end
    end
  end
end
