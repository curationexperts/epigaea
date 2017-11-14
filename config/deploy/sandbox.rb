set :rails_env, 'production'
# server '52.21.87.2', user: 'deploy', roles: [:web, :app, :db]
# server '52.72.119.114', user: 'deploy', roles: [:web, :app, :db]
server 'epigaea.curationexperts.com', user: 'deploy', roles: [:web, :app, :db]
