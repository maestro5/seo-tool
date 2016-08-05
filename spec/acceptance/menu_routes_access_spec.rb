require_relative '../acceptance_helper'

# ======================================
#   Guest
# ======================================

feature 'Guest menu items and routes', %q{
  As an guest
  of my menu items are available:
  Home, Sign Up, Log In
} do
  given!(:user_default) { create(:user_default) }
  before { visit '/' }

  scenario 'guest clicks the available menu items' do
    expect(page).to have_link 'Seo Tool'
    expect(page).to have_link 'Home'
    expect(page).to have_link 'Sign Up'
    expect(page).to have_link 'Log In'

    click_on('Log In')
    expect(current_path).to eq '/login'
    expect(page).to have_content 'Username'
    expect(page).to have_button 'Login'

    click_on('Sign Up')
    expect(current_path).to eq '/signup'
    expect(page).to have_content 'Email'
    expect(page).to have_button 'Sign up'

    click_on('Home')
    expect(current_path).to eq '/'
    expect(page).to have_button 'Run'

    click_on('Seo Tool')
    expect(current_path).to eq '/'
  end

  scenario 'guest tries to go private and non-existing routes' do
    expect(page).not_to have_link 'Log Out'
    expect(page).not_to have_link 'Settings'
    expect(page).not_to have_link 'Users'

    # --------------------------------
    # '/'
    # --------------------------------
    check_close_route '/logout'
    check_close_route '/settings'
    check_close_route '/settings/exit'
    check_close_route '/settings', :post

    check_no_exist_route '/no_exist'
    check_no_exist_route '/settings/no_exist'

    # --------------------------------
    # /reports/
    # --------------------------------
    check_no_exist_route '/reports'
    check_no_exist_route '/reports/1'
    check_no_exist_route '/reports/no_exist'

    # --------------------------------
    # /users/
    # --------------------------------
    check_close_route '/users'
    check_close_route '/users/1/clear_files'
    check_close_route '/users/1/clear_data'

    check_close_route '/users/1', :delete

    check_no_exist_route '/users/1'
    check_no_exist_route '/users/no_exist_url'
  end
end # Guest menu items

# ======================================
#   User
# ======================================

feature 'User menu items and routes', %q{
  As an user
  of my menu items are available:
  Settings, Log Out
} do
  given!(:user) { create(:user) }
  before { user_login user }

  scenario 'user clicks the available menu items' do
    expect(page).to have_link 'Settings'
    expect(page).to have_link 'Log Out'

    click_on 'Settings'
    expect(current_path).to eq '/settings'
    expect(page).to have_content 'Select a storage'
    expect(page).to have_link 'Exit'
    expect(page).to have_button 'Save'
  end # available menu items

  scenario 'user tries to go private and non-existing routes' do
    expect(page).not_to have_link 'Log In'
    expect(page).not_to have_link 'Sign Up'
    expect(page).not_to have_link 'Users'

    # --------------------------------
    # '/'
    # --------------------------------
    check_no_exist_route '/no_exist'
    check_no_exist_route '/settings/no_exist'

    # --------------------------------
    # /reports/
    # --------------------------------
    check_no_exist_route '/reports'
    check_no_exist_route '/reports/no_exist'

    # --------------------------------
    # /users/
    # --------------------------------
    check_close_route '/users'
    check_close_route '/users/1/clear_files'
    check_close_route '/users/1/clear_data'
    check_close_route '/users/1', :delete

    check_no_exist_route '/users/1'
    check_no_exist_route '/users/no_exist_url'
  end # private and non-existing routes
end # User menu items and routes

# ======================================
#   Admin
# ======================================

feature 'Admin menu items and routes', %q{
  As an admin
  of my menu items are available:
  Users, Settings, Log Out
} do
  given!(:user_admin) { create(:user_admin) }
  before { user_login user_admin }

  scenario 'admin clicks the available menu items' do
    expect(page).to have_link 'Users'
    expect(page).to have_link 'Settings'
    expect(page).to have_link 'Log Out'

    click_on 'Users'
    expect(current_path).to eq '/users'
    expect(page).to have_selector 'table'
    expect(page).to have_content 'user_admin@test.com'

    click_on 'Settings'
    expect(current_path).to eq '/settings'
    expect(page).to have_content 'Select a storage'
    expect(page).to have_link 'Exit'
    expect(page).to have_button 'Save'
  end # available menu items

  scenario 'admin tries to go private and non-existing routes' do
    expect(page).not_to have_link 'Sign Up'
    expect(page).not_to have_link 'Log In'

    # --------------------------------
    # '/'
    # --------------------------------
    check_no_exist_route '/no_exist'
    check_no_exist_route '/settings/no_exist'

    # --------------------------------
    # /reports/
    # --------------------------------
    check_no_exist_route '/reports/no_exist'
    check_no_exist_route '/reports'

    # --------------------------------
    # /users/
    # --------------------------------
    check_no_exist_route '/users/1'
    check_no_exist_route '/users/no_exist_url'
  end # private and non-existing routes
end # Admin menu items and routes
