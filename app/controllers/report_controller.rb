class ReportController < ApplicationController
 get '/reports' do
   if logged_in?
    @user = User.find_by_id(session[:user_id])
    erb :'/reports/show_report'
   else
    redirect to '/homepage/homepage'
   end
  end
  
  get '/create_report' do
  if logged_in?
   @user = User.find_by_id(session[:user_id])
   erb :'/reports/create_report'
  else
   erb :'/homepage/homepage'
  end
 end

 post '/create_report' do
  @report = Report.create(params[:report])
  @user = User.find_by_id(session[:user_id])
  @user.reports << @report
  
  #@companyreport = CompanyReport.new
  Statement.all.each do |sid|
   params[:company_ids].each do |id|
    @companyreport = CompanyReport.create(:company_id => id, :report_id => @report.id, :dimension_id => Statement.find_by_id(sid).dimension_id, :statement_id => sid.id)
    @report.company_reports << @companyreport
  end
  end
  binding.pry
 end
end

