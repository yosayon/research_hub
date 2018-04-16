class UserController < ApplicationController
 

 
 get '/homepage' do
   erb :"homepage/homepage"
 end

 get '/signup' do
  if !logged_in?
   erb :'/users/signup'
  else
   @user = User.find_by_id(session[:user_id])
   redirect to "/users/#{@user.slug}"
  end
 end

 
end