require "sinatra/activerecord/rake"
require "./app"
require './app/services/_init'

# Load all rake tasks
Dir.glob('lib/tasks/*.rake').each { |r| load r}

task default: :test

desc "Run all tests"
task(:test) do
  Dir['./test/**/*_test.rb'].each { |f| load f }
end
