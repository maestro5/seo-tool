require 'sinatra/base'
require './helpers/application_helpers'
require './controllers/application_controller'
require 'warden'
require './models/dm_user'

Dir.glob('./{helpers,controllers}/*.rb').each { |file| require file }

use Warden::Manager do |manager|
  manager.serialize_into_session { |user| user.id }
  manager.serialize_from_session { |id| DmUser.get(id) }
  manager.scope_defaults :default,
  strategies: [:password],
  action: '/unauthenticated'
  manager.failure_app = self
end

Warden::Manager.before_failure do |env, _opts|
  env['REQUEST_METHOD'] = 'POST'
end

# -----------------------------
# Warden authenticate strategy
# -----------------------------
class MyStrategy < Warden::Strategies::Base
  def valid?
    params['user'] && params['user']['username'] && params['user']['password']
  end

  def authenticate!
    email = params['user']['username'].downcase
    user = DmUser.first(email: email)

    if user.nil?
      fail!('Username does not exist.')
    elsif user.authenticate(params['user']['password'])
      success!(user)
    else
      fail!('Wrong password!')
    end
  end
end

Warden::Strategies.add(:password, MyStrategy)

map('/') { run WebsiteController }
map('/users') { run UsersController }
map('/reports') { run ReportsController }
