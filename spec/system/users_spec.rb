require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'sign in' do
    let(:alice) { create :user }

    it 'signs in' do
      visit new_user_session_path
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
      find('[data-rspec=sign_in]').click
      expect(page).to have_content 'ログインしました。'
    end
  end

  describe 'sign up' do
    let(:alice) { build_stubbed :user }

    it 'signs up' do
      visit new_user_registration_path
      fill_in 'user[name]', with: alice.name
      fill_in 'user[email]', with: alice.email
      fill_in 'user[password]', with: alice.password
      fill_in 'user[password_confirmation]', with: alice.password_confirmation
      expect do
        find('[data-rspec=sign_up]').click
      end.to change(User, :count).by(1)
      expect(page).to have_content 'アカウント登録が完了しました。'
    end
  end

  describe 'update' do
    let(:alice) { create :user, avatar: '', name: 'alice' }

    before { sign_in alice }

    it 'updates the avatar' do
      old_avatar_url = alice.avatar.url
      visit edit_user_registration_path
      attach_file 'user[avatar]', Rails.root.join('spec/fixtures/avatar.jpg')
      fill_in 'user[current_password]', with: alice.password
      find('[data-rspec=update]').click
      expect(page).to have_content 'アカウント情報を変更しました。'
      expect(alice.reload.avatar.url).not_to eq old_avatar_url
    end

    it 'updates the name' do
      visit edit_user_registration_path
      fill_in 'user[name]', with: 'アリス'
      fill_in 'user[current_password]', with: alice.password
      find('[data-rspec=update]').click
      expect(page).to have_content 'アカウント情報を変更しました。'
      expect(alice.reload.name).to eq 'アリス'
    end
  end
end
