#create route for user to update their profile

class UserController < ApplicationController
 
 get '/users/:slug' do #if user is logged in, render their 
 #dashboard, else redirect to login
  if logged_in?
   @user = User.find_by_slug(params[:slug])
   erb :'users/show'
  else
   erb :'/homepage/homepage'
  end
   
 end
 
 get '/signup' do #if user is not logged in, and wants to 
 #signup, then render the sign up form if not, send the user
 #to their dashboard.
  if !logged_in?
 erb :'/users/signup'
  else
   @user = User.find_by_id(session[:user_id])
   redirect to "/users/#{@user.slug}"
  end
 end
 
 post '/signup' do #after a user signs up send them back to
 #the login page.
  @user = User.create(params)
  session[:user_id] = @user.id
  redirect to '/login'
 end
 
 get '/homepage' do
   erb :"homepage/homepage"
 end
 
 
 get '/login' do #if the user is not logged in then send the 
 #user to the homepage to log in. If not, send the user
 #to their profile page.
  if !logged_in?
   erb :'/homepage/homepage'
  else
   @user = User.find_by_id(session[:user_id])
   redirect to "/users/#{@user.slug}"
  end
 end

  post '/login' do #authenticate the user login credentials
  #and redirect to their dashboard if authenticated else
  #redirect to the login route
  @user = User.find_by(:username => params[:username])
  if @user && @user.authenticate(params[:password])
   session[:user_id] = @user.id
   redirect to "/users/#{@user.slug}"
  else
   redirect to '/login'
  end
 end
 
 get '/logout' do #destroy session if logged in and redirect
 #to homepage, else if the user is not logged in, then redirect
 #to homepage
  if logged_in?
  session.destroy
  redirect '/'
  else
  redirect '/'
  end
 end
 
end