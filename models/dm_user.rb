require 'dm-core'
require 'dm-migrations'
require 'dm-constraints'
require 'dm-validations'
require 'yaml'
require 'bcrypt'
require './lib/storages_additions'

ENV['RACK_ENV'] ||= 'development'

db_config = YAML::load(File.read('./config/database.yml'))
DataMapper.setup :default, db_config[ENV['RACK_ENV']]

# ---------------------------
# User model with DataMapper
# ---------------------------
class DmUser
  include StoragesAdditions
  include BCrypt
  include DataMapper::Resource

  before :create do
    email.downcase!
  end

  property :id, Serial, key: true
  property :email, String, required: true, unique: true, format: :email_address
  property :password_hash, String, required: true, length: 60
  property :storage, String, default: 'dm', required: true
  property :admin, Boolean, default: false

  has n, :dm_reports, constraint: :destroy

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(password)
    self if self.password == password
  end
end
