require_relative '../acceptance_helper'

# ======================================
#   Guest
# ======================================

feature 'Guest Sign up', %q{
  As a guest
  I want to be able to sign up
} do

  before { visit '/signup' }

  context 'guest fills invalid data' do
    scenario 'when email has an invalid format' do
      fill_in 'user[email]', with: 'user@testcom'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[confirm]', with: 'password'

      expect { click_on 'Sign up' }.not_to change(DmUser, :count)
      expect(current_path).to eq '/signup'
      expect(page).to have_content 'Email has an invalid format'
    end

    scenario 'when email is already taken' do
      fill_in 'user[email]', with: create(:user).email
      fill_in 'user[password]', with: 'password'
      fill_in 'user[confirm]', with: 'password'

      expect { click_on 'Sign up' }.not_to change(DmUser, :count)
      expect(current_path).to eq '/signup'
      expect(page).to have_content 'Email is already taken'
    end

    scenario 'when password confirmation not eq password' do
      fill_in 'user[email]', with: 'user@test.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[confirm]', with: 'wrongpass'

      expect { click_on 'Sign up' }.not_to change(DmUser, :count)
      expect(current_path).to eq '/signup'
      expect(page).to have_content 'Password not equal password confirmation!'
    end
  end # invalid

  scenario 'guest fills valid data' do
    fill_in 'user[email]', with: 'user@test.com'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[confirm]', with: 'password'

    expect { click_on 'Sign up' }.to change(DmUser, :count).by(1)
    expect(current_path).to eq '/login'
    expect(page).to have_content 'Sign up success, congretulation! Now you can login'
  end # valid
end # Guest Sign up

# ======================================
#   User
# ======================================

feature 'User Log in', %q{
  As an user
  I want to be able to log in
} do

  given!(:user) { create(:user) }

  scenario 'user log in' do
    user_login user
    expect(current_path).to eq '/'
    expect(page).to have_content "Successfully logged in. Welcome #{user.email}!"
  end
end # User Log in

feature 'User Log out', %q{
  As an user
  I want to be able to log out
} do

  given!(:user_default) { create(:user_default) }
  given!(:user) { create(:user) }

  scenario 'user logs out' do
    user_login user
    click_on 'Log Out'

    expect(current_path).to eq '/'
    expect(page).to have_content 'Successfully logged out'
  end
end # User Log out
