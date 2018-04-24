class ReportController < ApplicationController
 
 get '/reports' do
  if logged_in?
   @user = User.find_by_id(session[:user_id])
   erb :'/reports/index'
  else
   redirect to '/login'
  end
 end
  
 get '/reports/new' do
  if logged_in?
   @user = User.find_by_id(session[:user_id])
   erb :'/reports/new'
  else
   redirect to '/login'
  end
 end
 
 get '/reports/:id' do
  if logged_in?
   @user = User.find_by_id(session[:user_id])
   @report = Report.find_by_id(params[:id].to_i)
   if @user.report_ids.include?(@report.id)
    erb :'reports/show'
   else
    redirect to "/login"
   end
  else
   redirect to "/login"
  end
 end

 post '/reports' do
  @report = Report.create(params[:report])
  @user = User.find_by_id(session[:user_id])

#if user selects at least one company, dimension and statement
  if params[:company_ids] && params[:statement_ids] && params[:dimension_ids]
  #iterate through all company ids
   params[:company_ids].each do |cid|
   #iterate through all Statements
    Statement.all.each do |sid|
     #create a companyreport
     @companyreport = CompanyReport.create(
      :company_id => cid.to_i, 
      :report_id => @report.id, 
      :dimension_id => Statement.find_by_id(sid.id).dimension_id, 
      :statement_id => sid.id)
      @report.company_reports << @companyreport
    end
   end
   #Select only the reports that matches the statements and dimensions that the user selected
   @report.company_reports = @report.company_reports.select{|report|params[:statement_ids].include?(report.statement_id.to_s) || params[:dimension_ids].include?(report.dimension_id.to_s)}
   #add the score_id to the company_report if the score object matches company_id and statement_id
   Score.all.each do |x|
    @report.company_reports.each{|report| report.update(:score_id => x.id) if x.company_id == report.company_id && x.statement_id == report.statement_id}
   end
   erb :"/reports/show"
#-------------------------------------------------------------     
#if the user selects only companies and dimensions
  elsif params[:company_ids]  && params[:statement_ids] == nil  && params[:dimension_ids]
   params[:company_ids].each do |cid|
    Statement.all.each do |sid|
     @companyreport = CompanyReport.create(
      :company_id => cid.to_i, 
      :report_id => @report.id, 
      :dimension_id => Statement.find_by_id(sid.id).dimension_id, 
      :statement_id => sid.id)
      @report.company_reports << @companyreport
     end
   end
   @report.company_reports = @report.company_reports.select{|report|params[:dimension_ids].include?(report.dimension_id.to_s)}
   Score.all.each do |x|
    @report.company_reports.each{|report| report.update(:score_id => x.id) if x.company_id == report.company_id && x.statement_id == report.statement_id}
   end
   erb :"/reports/show"
#-------------------------------------------------------------     
#if the user selects only companies and statements
  elsif params[:company_ids]  && params[:statement_ids] && params[:dimension_ids] == nil
   params[:company_ids].each do |cid|
    Statement.all.each do |sid|
     @companyreport = CompanyReport.create(
      :company_id => cid.to_i, 
      :report_id => @report.id, 
      :dimension_id => Statement.find_by_id(sid.id).dimension_id, 
      :statement_id => sid.id)
      @report.company_reports << @companyreport
     end
   end
   @report.company_reports = @report.company_reports.select{|report|params[:statement_ids].include?(report.statement_id.to_s)}
   Score.all.each do |x|
    @report.company_reports.each{|report| report.update(:score_id => x.id) if x.company_id == report.company_id && x.statement_id == report.statement_id}
   end
   erb :"/reports/show"
#-------------------------------------------------------------     
#if the user only selects a company or companies and nothing else..
  elsif params[:company_ids] && params[:statement_ids] == nil && params[:dimension_ids] == nil
   params[:company_ids].each do |cid|
    Statement.all.each do |sid|
     @companyreport = CompanyReport.create(
      :company_id => cid.to_i, 
      :report_id => @report.id, 
      :dimension_id => Statement.find_by_id(sid.id).dimension_id, 
      :statement_id => sid.id)
      @report.company_reports << @companyreport
    end
   end
   Score.all.each do |x|
    @report.company_reports.each{|report| report.update(:score_id => x.id) if x.company_id == report.company_id && x.statement_id == report.statement_id}
   end
   erb :"/reports/show"
#-------------------------------------------------------------     
   else
    flash[:message] = "Error: Please select at least one company to generate a report"
    redirect to "/reports/new"
   end
  end
#-------------------------------------------------------------  

 patch '/reports/:id' do
  @user = User.find_by_id(session[:user_id])
  @report = Report.find_by_id(params[:id])
  @user.reports << @report
  @user.save
  redirect to '/reports'
 end
 
 delete '/reports/:id' do
  @user = User.find_by_id(session[:user_id])
  Report.all.each{|report| report.delete if report.id == params[:id].to_i}
  @user.reports.each{|report| report.delete if report.id == params[:id].to_i}
  @user.save
  redirect to '/reports'
 end
 
 delete '/reports' do
  @user = User.find_by_id(session[:user_id])
  @user.reports.delete_all
  @user.save
  redirect to '/reports'
 end
 
end
  

    
    
