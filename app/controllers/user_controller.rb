class UserController < ApplicationController
 
 get '/users/:slug' do
  @user = User.find_by_id(session[:user_id])
  if current_user
   erb :'users/show'
  else
   erb :'/users/login'
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
  @user = User.find_by(:username => params[:username])
  if !@user.nil?
   flash[:message] = "username is already taken"
   erb :"users/signup"
  else
   @user = User.create(params)
   session[:user_id] = @user.id
   redirect to "/users/#{@user.slug}"
  end
 end
 
 get '/' do 
  if logged_in?
   redirect to "/login"
  else
   erb :'users/login'
  end
 end
 
 get '/login' do
  @user = User.find_by_id(session[:user_id])
  if @user && logged_in?
   session[:user_id] = @user.id
   redirect to "/users/#{@user.slug}"
  else
   erb :'users/login'
  end
 end
 
 post '/login' do
  @user = User.find_by(:username => params[:username])
  if @user && @user.authenticate(params[:password])
   session[:user_id] = @user.id
   redirect to "/users/#{@user.slug}"
  else
   flash[:message] = "Incorrect username or password, please try again"
   redirect to '/login'
  end
 end
 
 get '/logout' do
  session.destroy
  redirect '/login'
 end
 
end