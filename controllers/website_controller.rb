require './asset-handler'

# ---------------------
# '/' controller
# ---------------------
class WebsiteController < ApplicationController
  use AssetHandler

  helpers WebsiteHelpers

  get '/' do
    @reports = find_reports
    slim :"pages/index"
  end

  get '/signup' do
    @user = DmUser.new
    slim :"sessions/signup"
  end

  post '/signup' do
    unless params[:user][:password] == params[:user][:confirm]
      flash[:danger] = 'Password not equal password confirmation!'
      redirect to('/signup')
    end

    @user = DmUser.new(
      email: params[:user][:email],
      password: params[:user][:password]
    )

    if @user.save
      flash[:success] = 'Sign up success, congretulation! Now you can login'
      redirect to('/login')
    else
      slim :"sessions/signup"
    end
  end

  get '/settings' do
    protected!
    slim :"pages/settings"
  end

  get '/settings/exit' do
    protected!
    redirect '/'
  end

  post '/settings' do
    protected!
    flash[:success] = 'Settings saved' if save_settings
    redirect to('/')
  end
end # WebsiteController
