# ---------------------
# '/reports' controller
# ---------------------
class ReportsController < ApplicationController
  enable :method_override

  helpers ReportHelpers

  post '/' do
    @report = create_report

    if @report.nil?
      flash[:danger] = 'Url has an invalid format'
      redirect '/'
    end

    redirect to("/#{@report.id}") unless @report.errors.any?
    
    @reports = find_reports
    slim :"pages/index"
  end

  get '/:id' do
    @report = find_report
    redirect 'not_found' if @report.nil?
    slim :"reports/show_report"
  end

  delete '/:id' do
    flash[:success] = 'Report deleted' if find_report.destroy
    redirect '/'
  end
end # ReportsController
