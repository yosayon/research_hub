# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

source 'http://rubygems.org'

gem 'sinatra', :source => 'http://rubygems.org/'
gem 'activerecord', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord', :source => 'http://rubygems.org/'
gem 'rake'
gem 'require_all'
gem 'sqlite3', :source => 'http://rubygems.org/'
gem 'thin'
gem 'shotgun'
gem 'pry'
gem 'bcrypt'
gem "tux", :source => 'http://rubygems.org/'
gem "sinatra-flash", :source => 'http://rubygems.org/'
gem 'rack-flash3'


group :test do
  gem 'rspec'
  gem 'capybara', :source => 'http://rubygems.org/'
  gem 'rack-test'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'
end
