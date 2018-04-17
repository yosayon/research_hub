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
  
  params[:company_ids].each do |id|
  Statement.all.each do |sid|
    @companyreport = CompanyReport.create(:company_id => id, :report_id => @report.id, :dimension_id => Statement.find_by_id(sid.id).dimension_id, :statement_id => sid.id, :score_id => "hi" )
    @report.company_reports << @companyreport
  end
 end
 
 @report.company_reports.select{|report| params[:statement_ids].include?(report.statement_id.to_s) || params[:dimension_ids].include?(report.dimension_id.to_s)}

  binding.pry
 end
end

