# ----------------------------------
# Helpers for ApplicationController
# ----------------------------------
module ApplicationHelpers
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path = '/')
    request.path == path || request.path == path + '/'
  end

  def find_reports
    clear_reports unless authenticated?
    (current_user.send "#{current_storage}_reports").all
  end

  def clear_reports
    (current_user.send "#{current_storage}_reports").destroy
  end

  def current_storage
    current_user.storage
  end

  def file_storage?
    'checked' if current_storage == 'file'
  end

  def dm_storage?
    'checked' if current_storage == 'dm'
  end

  def se_storage?
    'checked' if current_storage == 'se'
  end

  def sql_storage?
    'checked' if current_storage == 'sql'
  end

  def date_format(date)
    date.strftime('%d.%m.%Y %H:%M:%S')
  end

  def short_url(url)
    url.gsub('http://', '')
  end

  def find_user
    DmUser.get(params[:id])
  end
end # ApplicationHelpers
