require 'spec_helper'
require './models/dm_user'
require './models/dm_report'
require './models/se_report'

RSpec.describe SqlReport do
  let(:user) { create(:user) }

  describe 'class methods' do
    let(:page) { { url: 'test.com', urls: '[]' } }

    it '.all' do
      expect(SqlReport).to respond_to(:all)
      expect(SqlReport.all).to match_array([])
    end

    it '.count' do
      expect(SqlReport).to respond_to(:count)
      expect(SqlReport.count).to eq 0
    end

    it '.create' do
      expect(SqlReport).to respond_to(:create).with(1).argument
      expect { user.sql_reports.create(page) }.to change(SqlReport, :count).by(+1)
    end

    it '.find' do
      report_id = user.sql_reports.create(page).id
      expect(SqlReport).to respond_to(:find).with(1).argument
      expect(SqlReport.find(report_id).url).to eq page[:url]
    end

    it '.first' do
      expect(SqlReport).to respond_to(:first)
      expect(SqlReport.first.url).to eq page[:url]
    end

    it '.last' do
      expect(SqlReport).to respond_to(:last)
      expect(SqlReport.last.url).to eq page[:url]
    end
  end # class methods

  describe 'object methods' do
    let(:urls) { [
      { name: 'link1', url: 'link1.com' },
      { name: 'link2', url: 'link2.com' }
    ] }
    let(:urls_str) { JSON.generate(urls) }
    let(:page) { {
      url:         'test.com',
      ip:          '89.184.83.163',
      location:    'Ukraine',
      server:      'nginx/1.6.2',
      title:       'test',
      description: 'test data',
      keywords:    'test, test, test',
      urls:        urls_str
    } }
    let(:report) { user.sql_reports.create(page) }

    it '#id' do
      expect(report).to respond_to(:id)
      expect(report.id).to be_kind_of(Integer)
    end

    it '#created_at' do
      expect(report).to respond_to(:created_at)
    end

    it '#url' do
      expect(report).to respond_to(:url)
      expect(report.url).to eq page[:url]
    end

    it '#ip' do
      expect(report).to respond_to(:ip)
      expect(report.ip).to eq page[:ip]
    end

    it '#location' do
      expect(report).to respond_to(:location)
      expect(report.location).to eq page[:location]
    end

    it '#server' do
      expect(report).to respond_to(:server)
      expect(report.server).to eq page[:server]
    end

    it '#title' do
      expect(report).to respond_to(:title)
      expect(report.title).to eq page[:title]
    end

    it '#description' do
      expect(report).to respond_to(:description)
      expect(report.description).to eq page[:description]
    end

    it '#keywords' do
      expect(report).to respond_to(:keywords)
      expect(report.keywords).to eq page[:keywords]
    end

    it '#links' do
      expect(report).to respond_to(:links)
      expect(report.links).to eq urls
    end

    it '#destroy' do
      expect(report).to respond_to(:destroy)
      expect { report.destroy }.to change(user.sql_reports, :count).by(-1)
    end
  end # object methods
end # SqlReport
