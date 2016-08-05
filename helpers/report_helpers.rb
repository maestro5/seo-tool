require 'httparty'
require 'nokogiri'
require 'geoip'

require './models/file_report'
require './models/dm_report'
require './models/se_report'
require './models/sql_report'

# ------------------------------
# Helpers for ReportsController
# ------------------------------
module ReportHelpers
  def format_url(url)
    !(/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/.match(url)).nil?
  end

  def create_report
    page = generate_report(params[:url].downcase)
    return unless page
    (current_user.send "#{current_storage}_reports").create(page)
  end

  def find_report
    report = (current_user.send "#{current_storage}_reports").find(params[:id])
    report.is_a?(Enumerator) ? current_user.dm_reports.get(params[:id]) : report
  end

  def generate_report(url)
    return unless format_url url

    prefix = 'http://'
    url = url.chomp('/')
    url = prefix + url unless url.include? prefix

    response = HTTParty.get(url)
    html_doc = Nokogiri::HTML(response)
    geo      = GeoIP.new('./db/GeoLiteCity.dat').city(url.gsub('http://', ''))

    location = geo.country_name
    location += ', ' + geo.city_name unless geo.city_name.empty?

    description, keywords = ''
    html_doc.css('meta').each do |el|
      description = el['content'] if el['name'] == 'description'
      keywords    = el['content'] if el['name'] == 'keywords'
    end

    links = []
    html_doc.css('a').each do |el|
      links << { name: el.text.chomp, url: el['href'], rel: el['rel'], target: el['target'] }
    end

    {
      url:         url,
      ip:          geo.ip,
      location:    location,
      server:      response.headers['server'],
      title:       html_doc.title,
      description: description,
      keywords:    keywords,
      urls:        JSON.generate(links)
    }
  end
end # ReportHelpers
