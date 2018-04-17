class UserController < ApplicationController
 
 
 get '/signup' do
  if session[:user_id]
   erb :'/users/signup'
   else
   @user = User.find_by_id(session[:user_id])
   redirect to "/users/#{@user.slug}"
  end
 end
 
 post '/signup' do
  @user = User.create(params)
  session[:user_id] = @user.id
  redirect to '/login'
 end
 
 get '/homepage' do
   erb :"homepage/homepage"
 end
 
 get '/login' do
  if !logged_in?
   erb :'/homepage/homepage'
  else
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
 
 get '/users/:slug' do
  if logged_in?
   @user = User.find_by_slug(params[:slug])
   erb :'users/show'
  else
   erb :'/homepage/homepage'
  end
 end
 
end