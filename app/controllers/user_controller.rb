class UserController < ApplicationController
 
 get '/users/:slug' do
  @user = User.find_by_id(session[:user_id])
  if current_user
   erb :'users/show'
  else
   erb :login
  end
 end
 
 get '/signup' do
  if !logged_in?
   erb :'/users/new'
  else
   @user = current_user
   redirect to "/users/#{@user.slug}"
  end
 end
 
 post '/signup' do
  @user = User.find_by(:username => params[:username])
  if @user
   flash[:message] = "username is already taken"
   erb :'users/new'
  else
   @user = User.create(params)
   session[:user_id] = @user.id
   redirect to "/users/#{@user.slug}"
  end
 end
 
 get '/' do 
  redirect to '/login'
 end

 get '/login' do
  if !logged_in?
   erb :login
  else
   @user = current_user
   redirect to "/users/#{@user.slug}"
  end
 end
 
 post '/login' do
  @user = User.find_by(:username => params[:username])
  if @user && @user.authenticate(params[:password])
   session[:user_id] = @user.id
   redirect to "/users/#{@user.slug}"
  else
   flash[:message] = "Incorrect username or password, please try again"
   erb :login
  end
 end
 
 get '/logout' do
  session.destroy
  erb :login
 end
 
end