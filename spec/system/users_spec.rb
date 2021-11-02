require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:alice) { create :user }

  it 'signs in' do
    visit new_user_session_path
    fill_in 'user[email]', with: alice.email
    fill_in 'user[password]', with: alice.password
    find('[data-rspec=sign_in]').click
    expect(page).to have_content 'ログインしました。'
  end
end
