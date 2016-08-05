require_relative 'abstract_storage'

# -----------------------------
# Report model with SQL
# -----------------------------
class SqlReport < AbstractStorage

  @@connection = PG::Connection.new(
    dbname:   @@db_config['database'],
    host:     @@db_config['host'],
    user:     @@db_config['user'],
    password: @@db_config['password']
  )

  attr_reader :id, :created_at, :url, :ip, :location,
    :server, :title, :description, :keywords, :links

  class << self
    def create(page)
      id = @@connection.exec('INSERT INTO dm_reports (
        created_at, url, ip, location, server, title, description, keywords, urls, dm_user_id
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING id',
        [
          Time.now,
          page[:url],
          page[:ip],
          page[:location],
          page[:server],
          page[:title],
          page[:description],
          page[:keywords],
          page[:urls],
          @@current_user_id
        ]
      )

      find(id[0]['id'].to_i)
    end

    def find(id)
      record = @@connection.exec(
        "SELECT * FROM dm_reports
        WHERE dm_user_id = $1 AND id = $2", [@@current_user_id, id]
      )

      new(record[0])
    end

    def all
      records = @@connection.exec(
        "SELECT * FROM dm_reports
        WHERE dm_user_id = $1", [@@current_user_id]
      )

      records.inject([]) { |a, e| a << new(e) }
    end
  end # self

  def initialize(record)
    @id          = record['id'].to_i
    @created_at  = DateTime.parse(record['created_at'])
    @url         = record['url']
    @ip          = record['ip']
    @location    = record['location']
    @server      = record['server']
    @title       = record['title']
    @description = record['description']
    @keywords    = record['keywords']
    @links = record['urls'].empty? ? [] : JSON.parse(record['urls'], symbolize_names: true)
  end

  def destroy
    @@connection.exec(
      'DELETE FROM dm_reports
      WHERE dm_user_id = $1 AND id = $2', [@@current_user_id, @id]
    )
  end
end # SqlReport
