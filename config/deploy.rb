# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'tabrec-api'
set :repo_url, 'git@github.com:martin-svk/tabrec-api.git'

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for keep_releases is 5
set :keep_releases, 3

# Rack environment
set :rack_env, :production

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  namespace :db do
    desc 'Migrate database'
    task :migrate do
      on roles(:app), in: :sequence, wait: 5 do
        within current_path do
          execute :rake, "db:migrate RACK_ENV=production"
        end
      end
    end

    desc 'Seed databse'
    task :seed do
      on roles(:app), in: :sequence, wait: 5 do
        within current_path do
          execute :rake, "db:seed RACK_ENV=production"
        end
      end
    end
  end

  # Running order
  after :publishing, 'db:migrate'
  after 'db:migrate', 'db:seed'
  after 'db:seed', :restart
end
