set :rails_env, 'production'
server 'mira-fc4.curationexperts.com', user: 'deploy', roles: [:web, :app, :db]
