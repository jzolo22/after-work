require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end


# require_relative './config/environment'
# require 'sinatra/activerecord/rake'

# desc "Start our app console"
# task :console do
#   # enables logging in Pry console whenever Active Record writes SQL for us
#   ActiveRecord::Base.logger = Logger.new(STDOUT)
#   # open Pry console, similar to binding.pry
#   Pry.start
# end
