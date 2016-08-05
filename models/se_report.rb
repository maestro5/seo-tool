require 'sequel'
require_relative 'abstract_storage'

# -----------------------------
# Report model with Sequel
# -----------------------------
class SeReport < AbstractStorage
  @@DB = Sequel.connect(@@db_config)

  attr_reader :id, :created_at, :url, :ip, :location, :server,
              :title, :description, :keywords, :links

  class << self
    def create(page)
      page[:created_at] = Time.now
      page[:dm_user_id] = @@current_user_id
      id = @@DB[:dm_reports].insert(page)
      find(id)
    end

    def find(id)
      new @@DB.from(:dm_reports)
        .where(dm_user_id: @@current_user_id)
        .where(id: id)
        .first
    end

    def all
      records = @@DB.from(:dm_reports).where(dm_user_id: @@current_user_id).all
      records.inject([]) { |a, e| a << new(e) }
    end
  end # self

  def initialize(record)
    @id          = record[:id]
    @created_at  = record[:created_at]
    @url         = record[:url]
    @ip          = record[:ip]
    @location    = record[:location]
    @server      = record[:server]
    @title       = record[:title]
    @description = record[:description]
    @keywords    = record[:keywords]
    @links = record[:urls].empty? ? [] : JSON.parse(record[:urls], symbolize_names: true)
  end

  def destroy
    @@DB.from(:dm_reports).where(dm_user_id: @@current_user_id).where(id: id).delete
  end
end # SeReport
