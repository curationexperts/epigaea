set :rails_env, 'production'
server 'epigaea.curationexperts.com', user: 'deploy', roles: [:web, :app, :db]
