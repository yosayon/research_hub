class UserController < ApplicationController
 
 get '/users/:slug' do
  if logged_in?  #validation: user cannot view another user's profile page
   @user = current_user
   erb :'users/show'
  else
   redirect to '/login'
  end
 end
 
 get '/users' do
  if !logged_in? #validation: user cannot see the signup page if they're aready logged in.
   erb :'/users/new'
  else
   redirect to "/users/#{current_user.slug}"
  end
 end
 
 post '/users' do
  @user = User.find_by(:username => params[:username])#validation: username and password cannot be blank
  if current_user || params[:username].empty? || params[:password].empty?
   flash[:message] = "username is already taken/must enter a username and a password"
   erb :'users/new'
  else
   @user = User.create(params)
   session[:user_id] = @user.id
   redirect to "/users/#{current_user.slug}"
  end
 end
 
 get '/' do 
  redirect to '/login'
 end

 get '/login' do
  if !logged_in? #validation: user cannot view the login page if they're already logged in
   erb :'/users/login'
  else
   #@user = current_user
   redirect to "/users/#{current_user.slug}"
  end
 end
 
 post '/login' do #validation: user must enter in correct username and password to log in
  @user = User.find_by(:username => params[:username])
  if @user && @user.authenticate(params[:password])
   session[:user_id] = @user.id
   redirect to "/users/#{current_user.slug}"
  else
   flash[:message] = "Incorrect username or password, please try again"
   erb :'users/login'
  end
 end
 
 get '/logout' do
  session.destroy
  redirect to '/login'
 end
 
end