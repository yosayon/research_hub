class ReportController < ApplicationController
 
 get '/reports' do #validation: user must be logged in to view their own reports
  if logged_in?
   @user = current_user
   erb :'/reports/index'
  else
   redirect to '/login'
  end
 end
  
 get '/reports/new' do #validation: user must be logged in to create a new report
  if logged_in?
   @user = current_user
   erb :'/reports/new'
  else
   redirect to '/login'
  end
 end
 
 get '/reports/:id' do #validation: user must be logged in and if the report id is in the user's array of report_ids, then show the report.
  if logged_in?
   @user = current_user
   @report = Report.find_by_id(params[:id])
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
   current_user.reports << @report
   current_user.save
   redirect to "/reports/#{@report.id}"
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
   current_user.reports << @report
   current_user.save
   redirect to "/reports/#{@report.id}"
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
   current_user.reports << @report
   current_user.save
   redirect to "/reports/#{@report.id}"
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
   current_user.reports << @report
   current_user.save
   redirect to "/reports/#{@report.id}"
#-------------------------------------------------------------     
   else
    flash[:message] = "Error: Please select at least one company to generate a report"
    redirect to "/reports/new"
   end
  end
#-------------------------------------------------------------  
#UPDATE

 get '/reports/:id/edit' do #validation: user must be logged in and the report id must be in the current_user's report_ids array.
  @report = Report.find_by_id(params[:id].to_i)
  if current_user && current_user.report_ids.include?(@report.id)
   @user = current_user
   erb :"reports/edit"
  else
   redirect to "/login"
  end
 end
 
 patch '/reports/:id/edit' do
  @report = Report.find_by_id(params[:id].to_i)
  @report.company_reports.clear
  
  if !params[:report][:name].empty? && !params[:report][:description].empty? && !params[:company_ids].empty?
   @report.update(:name => params[:report][:name], :description => params[:report][:description])
#if the user only selects a company or companies and nothing else..
   if params[:company_ids] && params[:statement_ids] == nil && params[:dimension_ids] == nil || params[:company_ids] && params[:statement_ids] == nil && params[:dimension_ids].count == 5
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
    current_user.reports << @report
    current_user.save
    redirect to "/reports/#{@report.id}"
#-----------------------------------------------------------------
#if user selects at least one company, dimension and statement
    elsif params[:company_ids] && params[:statement_ids] && params[:dimension_ids]
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
      @report.company_reports.each{|report| report.update(:score_id => x.id) if x.company_id == report.company_id && x  .statement_id == report.statement_id}
   end
   current_user.reports << @report
   current_user.save
   redirect to "/reports/#{@report.id}"
#------------------------------------------------------------- 
#if user selects at least one company and one dimension
  elsif params[:company_ids] && params[:statement_ids] == nil && params[:dimension_ids]
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
   current_user.reports << @report
   current_user.save
   redirect to "/reports/#{@report.id}"
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
   current_user.reports << @report
   current_user.save
   redirect to "/reports/#{@report.id}"
#-------------------------------------------------------------     
   else
     flash[:message] = "Error: Please select at least one company to generate a report"
     redirect to "/reports/#{@report.id}/edit"
   end
 #------------------------------------------------------------- 
 else
  flash[:message] = "Error: Report name and description cannot be blank"
  redirect to "/reports/#{@report.id}/edit"
 end
end
  #-------------------------------------------------------------   
 
 delete '/reports/:id' do
  Report.all.each{|report| report.delete if report.id == params[:id].to_i}
  current_user.reports.each{|report| report.delete if report.id == params[:id].to_i}
  current_user.save
  redirect to '/reports'
 end
 
 delete '/reports' do
  current_user.reports.delete_all
  current_user.save
  redirect to '/reports'
 end
 
end
  

    
    
