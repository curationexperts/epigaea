# config valid only for certain versions of Capistrano
lock ">=3.9.0"

# Restart options
set :passenger_restart_wait, 60

set :application, "epigaea"
set :repo_url, "https://github.com/curationexperts/epigaea.git"

# Default branch is :master
set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/opt/epigaea"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml"
append :linked_files, "config/secrets.yml"
append :linked_files, "config/epigaea_private_key.json"

# Production secrets need to go in a file called .env.production on the server
# in /opt/epigaea/shared
# See .env.sample for what environment variables need values set
append :linked_files, ".env.production"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "public/assets"
append :linked_dirs, "tmp/pids"
append :linked_dirs, "tmp/cache"
append :linked_dirs, "tmp/sockets"
append :linked_dirs, "log"

# Ensure workflows are loaded whenever we deploy. Otherwise, if you
# forget to load the workflows, many features will not work as expected.
task :load_workflows do
  on roles(:app) do
    within release_path do
      execute :bundle, 'exec rake hyrax:workflow:load RAILS_ENV=production'
    end
  end
end
after 'deploy:restart', 'load_workflows'

# Passenger is not consistently restarting, but the problem seems to
# be fixed by making it restart twice.
task :reenable_deploy_restart do
  ::Rake.application['passenger:restart'].reenable
  ::Rake.application['passenger:restart']
end
after 'deploy:restart', 'reenable_deploy_restart'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
