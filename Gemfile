# Gemfile
source 'https://rubygems.org'

# Ruby
ruby '2.1.3'

# Sinatra web framework
gem 'sinatra', '~> 1.4.5'
# Activerecord ORM
gem 'activerecord', '~> 4.1.6'
# Sinatra helpers and rake tasks
gem 'sinatra-activerecord', '~> 2.0.2'
# PostgreSQL adapter
gem 'pg', '~> 0.17.1'

group :development do
  # Thin web server
  gem 'thin', '~> 1.6.3'
  # Sinatra's rails console
  gem 'tux', '~> 0.3.0'
end

group :production do
  # Passenger server
  gem 'passenger', '~> 4.0.53'
end

# Deployment tool
gem 'capistrano', '~> 3.2.1'
gem 'capistrano-rbenv', '~> 2.0.2'
gem 'capistrano-bundler', '~> 1.1.3'
