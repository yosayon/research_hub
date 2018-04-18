class UserController < ApplicationController
 
 get '/users/:slug' do
  if logged_in?
   @user = User.find_by_slug(params[:slug])
   erb :'users/show'
  else
   erb :'/homepage/homepage'
  end
 end
 
 get '/signup' do
  @user = User.find_by_id(session[:user_id])
  if @user == nil
   erb :'/users/signup'
  else
   redirect to "/users/#{@user.slug}"
  end
 end
 
 post '/signup' do
  @user = User.create(params)
  session[:user_id] = @user.id
  redirect to '/login'
 end
 
 get '/homepage' do
  if logged_in?
   @user = User.find_by_id(session[:user_id])
  redirect to "/users/#{@user.slug}"
 else
   erb :"homepage/homepage"
  end
 end
 
 get '/login' do
  @user = User.find_by_id(session[:user_id])
  if logged_in?
   session[:user_id] = @user.id
   redirect to "/users/#{@user.slug}"
  else
   erb :'/homepage/homepage'
  end
 end

  post '/login' do
   @user = User.find_by_id(session[:user_id])
  if @user && @user.authenticate(params[:password]) && params[:username] == @user.username
   session[:user_id] = @user.id
   redirect to "/users/#{@user.slug}"
  else
   flash[:message] = "Incorrect username or password, please try again"
   redirect to '/login'
  end
 end
 
 get '/logout' do
  if logged_in?
  session.destroy
  redirect '/'
  else
  redirect '/'
  end
 end
 
 
 
end