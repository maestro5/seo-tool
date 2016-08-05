# ---------------------
# '/users' controller
# ---------------------
class UsersController < ApplicationController
  enable :method_override

  helpers UserHelpers

  get '/' do
    protected_admin!
    @users = DmUser.all
    slim :"pages/users"
  end

  get '/:id/clear_files' do
    protected_admin!
    user = find_user
    flash[:success] = if user.file_reports.destroy
      "#{user.email} reports files deleted!"
    end
    redirect to('/')
  end

  get '/:id/clear_data' do
    protected_admin!
    user = find_user

    flash[:success] = if user.dm_reports.destroy
      "#{user.email} data reports deleted!"
    end
    redirect to('/')
  end

  delete '/:id' do
    protected_admin!
    user = find_user

    flash[:success] = if user.file_reports.destroy && user.destroy
      "#{user.email} deleted!"
    end
    redirect to('/')
  end
end # UsersController
