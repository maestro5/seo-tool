require 'sinatra/base'
require 'sinatra/flash'
require 'slim'
require './lib/sinatra/auth'
require './lib/sinatra/style'

# ------------------
# Main controller
# ------------------
class ApplicationController < Sinatra::Base
  register Sinatra::Auth
  register Sinatra::Flash

  helpers ApplicationHelpers

  configure do
    set :views, 'views'
  end

  not_found do
    slim :"pages/not_found"
  end
end # ApplicationController
