set :rails_env, 'production'
server 'localhost', user: 'deploy', roles: [:web, :app, :db]
