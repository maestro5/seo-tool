require 'dm-core'
require 'dm-migrations'
require_relative 'abstract_storage'

# -----------------------------
# Report model with DataMapper
# -----------------------------
class DmReport < AbstractStorage
  include DataMapper::Resource

  property :id,          Serial, key: true
  property :created_at,  DateTime, default: Time.now
  property :url,         String,   default: ''
  property :ip,          String,   default: ''
  property :location,    String,   default: ''
  property :server,      String,   default: ''
  property :title,       Text,     default: ''
  property :description, Text,     default: ''
  property :keywords,    Text,     default: ''
  property :urls,        Text,     default: '', length: 200000

  belongs_to :dm_user

  def links
    urls.empty? ? [] : JSON.parse(urls, symbolize_names: true)
  end
end

DataMapper.finalize
