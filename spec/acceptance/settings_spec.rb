require_relative '../acceptance_helper'

# ======================================
#   Guest
# ======================================

feature 'User set settings', %q{
  As a user
  I want to be able to change settings (storage)
} do

  given!(:user) { create(:user) }
  before { user_login user }

  scenario 'user set File storage' do
    expect { set_storage 'File' }
      .to change { DmUser.get(user.id).storage }.from('dm').to('file')
    expect(current_path).to eq '/'
    expect(page).to have_content 'Settings saved'
  end

  scenario 'user set DataMapper storage' do
    expect { set_storage 'Database with DataMapper' }
      .not_to change { DmUser.get(user.id).storage }
    expect(current_path).to eq '/'
    expect(page).to have_content 'Settings saved'
  end

  scenario 'user set Sequel storage' do
    expect { set_storage 'Database with Sequel' }
      .to change { DmUser.get(user.id).storage }.from('dm').to('se')
    expect(current_path).to eq '/'
    expect(page).to have_content 'Settings saved'
  end

  scenario 'user set SQL storage' do
    expect { set_storage 'Database with SQL' }
      .to change { DmUser.get(user.id).storage }.from('dm').to('sql')
    expect(current_path).to eq '/'
    expect(page).to have_content 'Settings saved'
  end

  scenario 'user chooses storage and refuses' do
    visit '/settings'
    choose('Database with SQL')

    expect { click_on 'Exit' }.not_to change { DmUser.get(user.id).storage }
    expect(current_path).to eq '/'
    expect(page).not_to have_content 'Settings saved'
  end
end # User set settings
