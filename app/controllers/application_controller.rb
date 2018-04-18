require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    use Rack::Flash, :sweep => true
    set :session_secret, "theresearchhub"
  end


  get '/' do 
   if logged_in?
    @user = User.find_by_id(session[:user_id])
    redirect to "/users/#{@user.slug}"
   else
    erb :"homepage/homepage"
   end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

  end

end