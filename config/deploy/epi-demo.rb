set :rails_env, 'production'
server '52.21.87.2', user: 'deploy', roles: [:web, :app, :db]
