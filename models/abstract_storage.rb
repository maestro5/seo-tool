require 'yaml'
require 'json'

ENV['RACK_ENV'] ||= 'development'

# -----------------------------
# Base storage class
# -----------------------------
class AbstractStorage
  @@current_user_id = nil
  @@db_config = YAML::load(File.read('./config/database.yml'))
  @@db_config = @@db_config[ENV['RACK_ENV']]

  class << self
    def set_current_user(id)
      @@current_user_id = id
    end

    def count
      all.count
    end

    def first
      all.first
    end

    def last
      all.last
    end
  end # self

  def errors
    []
  end
end
