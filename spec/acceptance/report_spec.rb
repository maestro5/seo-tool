require_relative '../acceptance_helper'

# ======================================
#   Guest
# ======================================

feature 'Guest creates a report', %q{
  As a guest
  I want to be able to create a report
} do

  given!(:user_default) { create(:user_default) }

  before { visit '/' }

  scenario 'guest create a report when invalid url' do
    fill_in 'url', with: 'invalid_url'
    click_on 'Run'

    expect(current_path).to eq '/'
    expect(page).to have_content 'Url has an invalid format'
  end # when invalid url

  scenario 'guest create a report when valid url' do
    fill_in 'url', with: 'github.com'

    expect { click_on 'Run' }.to change(DmReport, :count).by(1)
    expect(current_path).to include '/reports/'
    expect(page).to have_content 'Report for github.com'
    expect(page).not_to have_button 'Delete'

    visit '/'
    expect(page).not_to have_selector 'table'
    expect(page).not_to have_content 'github.com'
  end
end # Guest create a report

# ======================================
#   User
# ======================================

feature 'User creates, shows and deletes reports', %q{
  As an user
  I want to be able to create,
  see one or all my reports
  and delete report from reports list or report page
} do

  given!(:user) { create(:user) }

  before { user_login user }

  scenario 'user create, show and delete File reports' do
    set_storage 'File'
    3.times do
      create_and_check_report obj: FileReport
      sleep(1)
    end
    check_list_view_delete
  end

  scenario 'user want to see DataMapper reports' do
    set_storage 'Database with DataMapper'
    3.times { create_and_check_report obj: DmReport }
    check_list_view_delete
  end

  scenario 'user want to see Sequel reports' do
    set_storage 'Database with Sequel'
    3.times { create_and_check_report obj: SeReport }
    check_list_view_delete
  end

  scenario 'user want to see SQL reports' do
    set_storage 'Database with SQL'
    3.times { create_and_check_report obj: SqlReport }
    check_list_view_delete
  end
end # User creates, shows and deletes reports
