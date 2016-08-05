require './models/se_report'
require './models/sql_report'
require './models/file_report'

# ------------------------
# User storage additions
# ------------------------
module StoragesAdditions
  def se_reports
    SeReport.set_current_user id
    SeReport
  end

  def sql_reports
    SqlReport.set_current_user id
    SqlReport
  end

  def file_reports
    FileReport.set_current_user id
    FileReport
  end
end
