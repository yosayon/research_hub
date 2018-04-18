ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

task :console do
  Pry.start
end

desc 'Remove all data from database except users'
task :clear_database do
 Company.delete_all
 Dimension.delete_all
 Statement.delete_all
 Score.delete_all
 CompanyReport.delete_all
end

desc 'Clear database and schema'
task :drop! do
  # delete files
  File.delete("./db/development.sqlite") and File.delete("./db/schema.rb")
  # run migration
  Rake::Task['db:migrate'].reenable
  Rake::Task['db:migrate'].invoke
end
