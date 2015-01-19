require "sinatra/activerecord/rake"
require "./app"

task :default => :test

desc "Run all tests"
task(:test) do
  Dir['./test/**/*_test.rb'].each { |f| load f }
end
