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
  binding.pry
 end
end

