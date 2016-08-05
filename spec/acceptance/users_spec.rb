require_relative '../acceptance_helper'

feature 'Admin Users', %q{
  As an admin
  I want to be able to see Users list,
  destroy user's file and database reports,
  destroy user
} do

  given(:user_admin) { create(:user_admin) }
  before { user_login user_admin }

  scenario 'admin destroys user account, file and db reports' do
    content = { url: 'test.com', title: 'test page', urls: '[]' }
    file_report = ''

    users = create_list(:user, 2)
    users.each do |user|
      (0..1).each do |f|
        content[:url] = "test#{f}.com"
        file_report = user.file_reports.create(content)
      end
      user.dm_reports.create content
      user.se_reports.create content
      user.sql_reports.create content
    end

    visit '/users'
    expect(current_path).to eq '/users'

    # --------------------------------
    # reports count
    # --------------------------------
    check_user_line user: user_admin, file: '0', data: '0'
    users.each { |user| check_user_line user: user, file: '2', data: '3' }

    # --------------------------------
    # clear file reports
    # --------------------------------
    within("\#user_#{users[0].id}") do
      expect { click_on 'Clear files' }
        .to change { users[0].file_reports.count }.by(-2)
    end

    expect(current_path).to eq '/users/'
    expect(page).to have_content "#{users[0].email} reports files deleted!"
    check_user_line user: users[0], file: '0', data: '3'

    # --------------------------------
    # clear data reports
    # --------------------------------
    within("\#user_#{users[0].id}") do
      expect { click_on 'Clear data' }.to change(DmReport, :count).by(-3)
    end

    expect(current_path).to eq '/users/'
    expect(page).to have_content "#{users[0].email} data reports deleted!"
    check_user_line user: users[0], file: '0', data: '0'

    # --------------------------------
    # delete user
    # --------------------------------
    within("\#user_#{users[1].id}") do
      expect { click_on 'Delete' }
        .to change(DmUser, :count).by(-1)
        .and change(FileReport, :count).by(-2)
        .and change(DmReport, :count).by(-3)
    end

    expect(page).to have_content "#{users[1].email} deleted!"
    expect(Dir.exist? file_report.user_folder).to be false

    visit '/users'
    expect(page).not_to have_content users[1].email
  end # admin destroys user account, file and db reports
end # Admin Users
