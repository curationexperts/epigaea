# config valid only for current version of Capistrano
lock "3.9.0"

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
append :linked_files, "config/blacklight.yml"
append :linked_files, "config/fedora.yml"
append :linked_files, "config/redis.yml"
append :linked_files, "config/secrets.yml"
append :linked_files, "config/solr.yml"
append :linked_files, "config/handle.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "public/assets"
append :linked_dirs, "tmp/pids"
append :linked_dirs, "tmp/cache"
append :linked_dirs, "tmp/sockets"
append :linked_dirs, "log"

# link the draft dir specified in config/environments/produciton.rb config.drafts_storage_dir
append :linked_dirs, "tmp/drafts"

# link the draft dir specified in config/environments/production.rb config.exports_storage_dir
append :linked_dirs, "tmp/exports"

# link the template dir specified in config/environments/produciton.rb config.templates_storage_dir
append :linked_dirs, "tmp/templates"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
