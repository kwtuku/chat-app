module SignInModule
  def sign_in(user)
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    find('[data-rspec=sign_in]').click
  end
end
