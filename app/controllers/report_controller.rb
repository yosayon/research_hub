class ReportController < ApplicationController
 get '/reports' do
   if logged_in?
    @user = User.find_by_id(session[:user_id])
    erb :'/reports/reports'
   else
    redirect to '/login'
   end
  end
  
  get '/create_report' do
  if logged_in?
   @user = User.find_by_id(session[:user_id])
   erb :'/reports/create_report'
  else
   erb :'homepage'
  end
 end
 
 get '/reports/:id' do
  @user = User.find_by_id(session[:user_id])
  @report = Report.find_by_id(params[:id].to_i)
  if @user.report_ids.include?(@report.id)
  erb :"/reports/show_report"
  else
  erb :'/users/show'
  end
 end

 post '/create_report' do
  @report = Report.create(params[:report])
  @user = User.find_by_id(session[:user_id])
  
  if params[:company_ids] && params[:statement_ids] && params[:dimension_ids]
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
   
    @report.company_reports = @report.company_reports.select{|report|params[:statement_ids].include?(report.statement_id.to_s) || params[:dimension_ids].include?(report.dimension_id.to_s)}

    Score.all.each do |x|
     @report.company_reports.each{|report| report.update(:score_id => x.id) if x.company_id == report.company_id && x.statement_id == report.statement_id}
     end
     erb :"/reports/show_report"
     
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
    erb :"/reports/show_report"
    
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
    erb :"/reports/show_report"
    
     #if the user only selects a company and nothing else..
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
    erb :"/reports/show_report"
    
   else
    flash[:message] = "Error: Please select at least one company to generate a report"
    redirect to "/create_report"
   end
  end
  
  patch '/reports/:id' do
  @user = User.find_by_id(session[:user_id])
  @report = Report.find_by_id(params[:id])
  if logged_in?
   @user.reports<< @report
   @user.save
   erb :"reports/reports"
  else
   erb :homepage
  end
  end
 
 delete '/reports/:id' do
  @user = User.find_by_id(session[:user_id])
  if logged_in?
   Report.all.each{|report| report.delete if report.id == params[:id].to_i}
   @user.reports.each{|report| report.delete if report.id == params[:id].to_i}
   @user.save
    erb :"/reports/reports"
  else
   erb :homepage
  end
 end
 
 delete '/reports' do
  @user = User.find_by_id(session[:user_id])
  @user.reports.delete_all
  @user.save
  erb :"/reports/reports"
 end

end
  

    
    
