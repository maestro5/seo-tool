require 'sinatra/base'
require 'sinatra/flash'
require 'warden'

module Sinatra
  # ------------------------
  # Authenticated
  # ------------------------
  module Auth
    # ------------------------
    # Authenticated helpers
    # ------------------------
    module Helpers
      def authenticated?
        env['warden'].authenticated?
      end

      def protected!
        halt 401, slim(:unauthorized) unless authenticated?
      end

      def protected_admin!
        unless authenticated? && current_user.admin?
          halt 401, slim(:unauthorized)
        end
      end

      def current_user
        env['warden'].user || default_user
      end

      def default_user
        DmUser.first(email: 'default@default.com')
      end
    end

    def self.registered(app)
      app.helpers Helpers

      app.enable :sessions

      app.get '/login' do
        slim :"sessions/login"
      end

      app.post '/login' do
        env['warden'].authenticate!
        flash[:success] = env['warden'].message ||
          "Successfully logged in. Welcome #{current_user.email}!"
        redirect to '/'
      end

      app.get '/logout' do
        protected!
        env['warden'].raw_session.inspect
        env['warden'].logout
        flash[:success] = 'Successfully logged out'
        redirect '/'
      end

      app.post '/unauthenticated' do
        session[:return_to] = env['warden.options'][:attempted_path]
        puts env['warden.options'][:attempted_path]
        flash[:danger] = env['warden'].message || 'You must log in'
        redirect '/login'
      end
    end
  end

  register Auth
end
