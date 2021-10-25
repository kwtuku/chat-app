require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:alice) { create :user }

  it 'signs in' do
    visit new_user_session_path
    fill_in 'user[email]', with: alice.email
    fill_in 'user[password]', with: alice.password
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
  end

  it 'works with js', js: true do
    visit new_user_session_path
    fill_in 'user[email]', with: alice.email
    fill_in 'user[password]', with: alice.password
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    find('.btn-close').click
    expect(page).not_to have_content 'ログインしました。'
  end
end
