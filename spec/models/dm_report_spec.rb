require 'spec_helper'
require './models/dm_user'
require './models/dm_report'

RSpec.describe DmReport do
  let(:user) { create(:user) }
  let(:urls) { [
    { name: 'link1', url: 'link1.com' },
    { name: 'link2', url: 'link2.com' }
  ] }
  let(:urls_str) { JSON.generate(urls) }
  let(:page) { {
    url: 'test.com',
    urls: urls_str
  } }
  let(:report) { user.dm_reports.create(page) }

  it '#links' do
    expect(report).to respond_to(:links)
    expect(report.links).to eq urls
  end

  it '#dm_user' do
    expect(report).to respond_to(:dm_user)
    expect(report.dm_user).to eq user
  end
end
