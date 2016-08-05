require 'spec_helper'
require './models/dm_user'
require './models/dm_report'
require './models/file_report'

RSpec.describe FileReport do
  let(:user) { create(:user) }
  let(:options) { FileReport.options }

  describe 'class methods' do
    let(:page) { { url: 'http://test.com', urls: '[]' } }

    it '.options' do
      expect(FileReport).to respond_to(:options)

      expect(options).to have_key(:folder)
      expect(options).to have_key(:delimiter)
      expect(options).to have_key(:format)

      expect(options[:folder]).not_to be_nil
      expect(options[:delimiter]).not_to be_nil
      expect(options[:format]).not_to be_nil
    end

    it '.create_user_folder!' do
      user_folder = options[:folder] + "#{user.id}/"
      expect(FileReport).to respond_to(:create_user_folder!)
      expect(Dir).not_to exist(user_folder)
      expect(user.file_reports.create_user_folder!).to eq user_folder
      expect(Dir).to exist(user_folder)
    end

    it '.all' do
      expect(FileReport).to respond_to(:all)
      expect(FileReport.all).to match_array([])
    end

    it '.count' do
      expect(FileReport).to respond_to(:count)
      expect(FileReport.count).to eq 0
    end

    it '.create' do
      expect(FileReport).to respond_to(:create).with(1).argument
      expect { user.file_reports.create(page) }
        .to change(FileReport, :count).by(+1)
    end

    it '.find' do
      report_id = user.file_reports.create(page).id
      expect(FileReport).to respond_to(:find).with(1).argument
      expect(FileReport.find(report_id).url).to eq page[:url]
    end

    it '.first' do
      expect(FileReport).to respond_to(:first)
      expect(FileReport.first.url).to eq page[:url]
    end

    it '.last' do
      expect(FileReport).to respond_to(:last)
      expect(FileReport.last.url).to eq page[:url]
    end

    it 'sort_reports' do
      expect(FileReport).to respond_to(:sort_reports).with(2).arguments

      page_2 = { url: 'http://test2.com', urls: [] }
      user.file_reports.create(page)
      sleep(1)
      user.file_reports.create(page_2)

      reports = FileReport.all('DESC')
      expect(reports.first.created_at).to be > reports.last.created_at

      reports = FileReport.all('ASC')
      expect(reports.first.created_at).to be < reports.last.created_at
    end

    it '.destroy' do
      expect(FileReport.count).to eq 2
      expect(FileReport).to respond_to(:destroy)

      FileReport.destroy
      expect(FileReport.count).to eq 0
    end
  end # class methods

  describe 'object methods' do
    let(:urls) { [
      { name: 'link1', url: 'link1.com' },
      { name: 'link2', url: 'link2.com' }
    ] }
    let(:urls_str) { JSON.generate(urls) }
    let(:page) { {
      url: 'test.com',
      ip: '89.184.83.163',
      location: 'Ukraine',
      server: 'nginx/1.6.2',
      title: 'test',
      description: 'test data',
      keywords: 'test, test, test',
      urls: urls_str
    } }
    let(:report) { user.file_reports.create(page) }

    it '#page_url' do
      expect(report).to respond_to(:page_url)
      expect(report.url).to eq "http://#{page[:url]}"
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

    it '#server' do
      expect(report).to respond_to(:server)
      expect(report.server).to eq page[:server]
    end

    it '#location' do
      expect(report).to respond_to(:location)
      expect(report.location).to eq page[:location]
    end

    it '#ip' do
      expect(report).to respond_to(:ip)
      expect(report.ip).to eq page[:ip]
    end

    it '#links' do
      expect(report).to respond_to(:links)
      expect(report.links).to eq urls
    end

    it '#created_at' do
      expect(report).to respond_to(:created_at)
    end

    it '#user_folder' do
      user_folder = options[:folder] + "#{user.id}/"

      expect(report).to respond_to(:user_folder)
      expect(report.user_folder).to eq user_folder
    end

    it '#new_id' do
      expect(report).to respond_to(:new_id)

      new_id = report.new_id
      expect(new_id).to be_kind_of(String)
      expect(new_id).to include(report.page_url)
    end

    it '#new_full_name' do
      expect(report).to respond_to(:new_full_name)

      report
      sleep(1)
      new_full_name = report.new_full_name

      expect(new_full_name).to be_kind_of(String)
      expect(new_full_name).not_to eq report.find_full_name({ report_id: report.id })
      expect(new_full_name).to include(report.user_folder)
      expect(new_full_name).to include(report.page_url)
      expect(new_full_name).to include(options[:delimiter])
      expect(new_full_name).to include(options[:format])
    end

    it '#find_full_name' do
      expect(report).to respond_to(:find_full_name).with(1).argument

      full_name_from_id = report.find_full_name({ report_id: report.id })
      expect(full_name_from_id).to be_kind_of(String)
      expect(full_name_from_id).to include(report.user_folder)
      expect(full_name_from_id).to include(report.page_url)
      expect(full_name_from_id).to include(options[:delimiter])
      expect(full_name_from_id).to include(options[:format])

      full_name_from_full_name = report.find_full_name({ full_name: full_name_from_id })
      expect(full_name_from_full_name).to be_kind_of(String)
      expect(full_name_from_full_name).to eq full_name_from_id

      sleep(1)
      new_full_name = report.find_full_name({})
      expect(new_full_name).not_to eq full_name_from_id
    end

    it '#id' do
      expect(report).to respond_to(:id)
      expect(report.id).to be_kind_of(String)
    end

    it '#url' do
      expect(report).to respond_to(:url)
      expect(report.url).to eq "http://#{page[:url]}"
    end

    it '#created' do
      expect(report).to respond_to(:created)
      expect(report.created).to be_kind_of(DateTime)
    end

    it '#write!' do
      full_name = report.find_full_name({ report_id: report.id })
      expect(report).to respond_to(:write!)
      expect(report.write!).to eq report
      expect(File.size(full_name)).not_to eq 0
    end

    it '#read!' do
      expect(report).to respond_to(:read!)
      expect(report.read!).to eq report
    end

    it '#destroy' do
      expect(report).to respond_to(:destroy)
      expect { report.destroy }.to change(user.file_reports, :count).by(-1)
    end
  end # object methods
end # FileReport
