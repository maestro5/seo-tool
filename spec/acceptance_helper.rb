require 'spec_helper'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'rack/test'

Capybara.app = eval('Rack::Builder.new {( ' + File.read( + './config.ru') + "\n )}")

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rack::Test::Methods
end

def app() Capybara.app end

# ---------------
# Helpers
# ---------------
def parse_output(output)
  res = []
  output_array = output.split("\n")
  output_array.each { |line| res << line.delete('|').split }
  res
end

def user_login(user)
  visit '/login'
  fill_in 'user[username]', with: user.email
  fill_in 'user[password]', with: 'password'
  click_on 'Login'
end

def set_storage(storage)
  visit '/settings'
  choose(storage)
  click_on 'Save'
end

def create_and_check_report(options = {})
  return false unless options || options[:obj]

  url = 'github.com'
  fill_in 'url', with: url

  expect { click_on 'Run' }.to change(options[:obj], :count).by(1)
  expect(current_path).to include '/reports/'
  expect(page).to have_content "Report for #{url}"

  visit '/'
  expect(page).to have_selector 'table'
  expect(page).to have_content url
end

def check_list_view_delete
  # --------------------------------
  # show reports list
  # --------------------------------
  visit '/'
  expect(page).to have_selector 'table'
  expect(page).to have_selector '#report_0'
  expect(page).to have_selector '#report_1'
  expect(page).to have_selector '#report_2'
  expect(page).to have_link('github.com', href: 'http://github.com')

  # --------------------------------
  # view report
  # --------------------------------
  find('#report_1').click_on 'View'
  expect(current_path).to include('/reports/')
  expect(page).to have_content 'Report for'

  # --------------------------------
  # delete report from report page
  # --------------------------------
  click_on 'Delete'
  expect(current_path).to eq '/'
  expect(page).to have_content 'Report deleted'
  expect(page).not_to have_selector('#report_2')

  # --------------------------------
  # delete report from reports list
  # --------------------------------
  visit '/'
  find('#report_0').click_on 'Delete'
  expect(current_path).to eq '/'
  expect(page).to have_content 'Report deleted'
  expect(page).not_to have_selector('#report_1')
  expect(page).to have_selector('#report_0')
end

def check_user_line(options = {})
  return false unless options || options[:user] || options[:file] || options[:data]

  user = options[:user]
  within("\#user_#{user.id}") do
    expect(page).to have_content user.email
    expect(page).to have_content user.storage
    expect(page).to have_content user.admin

    within('.file_reports') do
      expect(page).to have_content options[:file]
    end

    within('.data_reports') do
      expect(page).to have_content options[:data]
    end

    expect(page).to have_link 'Clear files'
    expect(page).to have_link 'Clear data'
    if user.admin?
      expect(page).not_to have_button 'Delete'
    else
      expect(page).to have_button 'Delete'
    end
  end
end

def check_close_route(route, method = :get)
  case method
  when :get then visit route
  when :post then post route
  when :delete then delete route
  end

  expect(current_path).to eq '/login'
  expect(page).to have_content 'You must log in'
end

def check_no_exist_route(route)
  visit route
  expect(page).to have_content 'The page you are looking for is missing.'
  expect(page).to have_link 'home page'
end
