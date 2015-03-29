# Gemfile
source 'https://rubygems.org'

# Ruby
ruby '2.2.1'

# Sinatra web framework
gem 'sinatra', git: 'git@github.com:sinatra/sinatra.git'
# Sinatra contribs including json
gem 'sinatra-contrib', '~> 1.4.2'
# Activerecord ORM
gem 'activerecord', '~> 4.2.0'
# Sinatra helpers and rake tasks
gem 'sinatra-activerecord', '~> 2.0.5'
# PostgreSQL adapter
gem 'pg', '~> 0.18.1'

group :development do
  # Thin web server
  gem 'thin', '~> 1.6.3'
  # Pry inspection
  gem 'pry', '~> 0.10.1'
  # Sinatra's rails console
  gem 'tux', '~> 0.3.0'
end

group :test do
  gem 'rack-test', '~> 0.6.3'
end

# Deployment tool
gem 'capistrano', '~> 3.3.5'
gem 'capistrano-rbenv', '~> 2.0.3'
gem 'capistrano-bundler', '~> 1.1.4'
