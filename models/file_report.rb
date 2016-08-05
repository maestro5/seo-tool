require 'fileutils'
require_relative 'abstract_storage'

# -----------------------------
# Report model with File
# -----------------------------
class FileReport < AbstractStorage
  @@options = YAML::load(File.read('./config/file_storage.yml'))
  @@options = @@options[ENV['RACK_ENV']]

  attr_reader :page_url, :title, :description, :keywords,
    :server, :location, :ip, :links, :created_at, :user_folder

  class << self
    def options
      @@options
    end

    def create_user_folder!
      dir = @@options[:folder] + "#{@@current_user_id}/"
      return dir if Dir.exist?(dir)
      dir if Dir.mkdir(dir)
    end

    def create(page)
      create_user_folder!
      new(page: page).write!
    end

    def find(report_id)
      new(report_id: report_id).read!
    end

    def all(order = 'DESC')
      dir     = create_user_folder!
      files   = Dir.entries(dir).select { |f| !File.directory? f }
      reports = files.inject([]) { |a, e| a << new(full_name: e) } unless files.nil?
      sort_reports reports, order
    end

    def sort_reports(reports, order = 'DESC')
      reports.sort_by! { |name| name.created_at }
      reports.reverse! if order == 'DESC'
      reports
    end

    def destroy
      folder = @@options[:folder] + @@current_user_id.to_s if @@current_user_id
      FileUtils.rm_rf folder
    end
  end # self

  def initialize(params = {})
    @user_folder = @@options[:folder] + @@current_user_id.to_s + '/' if @@current_user_id

    if params[:page]
      @report = params[:page]
      init_properties
    end

    @full_name  = find_full_name(params)
    @created_at = created
  end

  def new_id
    @page_url.gsub('http://', '') +
      @@options[:delimiter] +
      Time.now.to_s.gsub(/[^0-9]/, '')[0...14]
  end

  def new_full_name
    @user_folder + new_id + @@options[:format]
  end

  def find_full_name(params)
    return params[:full_name] if params[:full_name]
    return new_full_name unless params[:report_id]

    @user_folder + params[:report_id] + @@options[:format]
  end # 'finviz.com*20150919153613' -> 'public/reports/5/finviz.com*20150919153613.report'

  def id
    path = @full_name.gsub(@user_folder, '')
    path.gsub(@@options[:format], '')
  end # 'public/reports/5/finviz.com*20150919153613.report' -> 'finviz.com*20150919153613'

  def url
    name = @full_name[0...delimiter_position]
    name = 'http://' + name
    name.gsub(@user_folder, '')
  end # 'public/reports/finviz.com*20150919153613.report' -> 'finviz.com'

  def created
    date_time = @full_name[delimiter_position...format_position]
    begin
      DateTime.parse(date_time)
    rescue
      false
    end
  end # 'public/reports/finviz.com*20150919153613.report' -> '15.09.2015 15:36:13'

  def write!
    self if File.open(@full_name, 'a') { |f| f.write(JSON.generate(@report)) }
  end

  def read!
    return false unless @created_at
    @report = JSON.parse(File.read(@full_name), symbolize_names: true)
    init_properties
    self
  end

  def destroy
    File.delete(@full_name)
  end

  private

  def init_properties
    return unless @report
    @page_url    = @report[:url]
    @title       = @report[:title]
    @description = @report[:description]
    @keywords    = @report[:keywords]
    @server      = @report[:server]
    @location    = @report[:location]
    @ip          = @report[:ip]
    @links = @report[:urls].empty? ? [] : JSON.parse(@report[:urls], symbolize_names: true)
  end

  def delimiter_position
    @full_name.rindex(@@options[:delimiter])
  end

  def format_position
    @full_name.rindex(@@options[:format])
  end
end
