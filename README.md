# Epigaea

[![ci](https://travis-ci.org/curationexperts/epigaea.svg?branch=master)](https://travis-ci.org/curationexperts/epigaea)
[![Coverage Status](https://coveralls.io/repos/github/curationexperts/epigaea/badge.svg?branch=master)](https://coveralls.io/github/curationexperts/epigaea?branch=master)

A [MIRA](https://github.com/TuftsUniversity/MIRA) replacement running on [Hyrax](https://github.com/samvera/hyrax) 2.0.

## Development

### dependencies
* MySQL
* Redis
* Path to [FITS](https://projects.iq.harvard.edu/fits/downloads) in the [Hyrax initializer](https://github.com/curationexperts/epigaea/blob/master/config/initializers/hyrax.rb)
* sidekiq as queue adapter in [application.rb](https://github.com/curationexperts/epigaea/blob/master/config/):        `config.active_job.queue_adapter = :sidekiq`


### initial setup
Get started by cloning the repository, installing the dependencies, and ensuring the test suite runs:

```sh
git clone https://github.com/curationexperts/epigaea.git
cd epigaea
bundle install
bundle exec sidekiq -d -l tmp/sidekiq.log

# start each of the next services in their own terminal session
bundle exec rake hydra:server 
bundle exec rake hydra:test_server

#back in your main terminal session
bundle exec rails db:setup
bundle exec rake spec
```

### running the development environment server
You need to start up the LDAP server using the `ladle` task and Solr, Fedora, and a webserver using the `hydra:server` task.
It's usually best to run each service in it's own terminal session.
```sh
# if you checked out new code, run the next two commands
# bundle install
# bundle exec rake db:migrate
bundle exec rake ladle      #start an LDAP server in a new window
bundle exec hydra:server    #start the development server, fedora, and solr in a new window
# visit http://localhost:3000
```

The applicaiton is configured to use LDAP for authentication.  The development and test 
environments use the [ladle](https://github.com/NUBIC/ladle) gem to launch a self-contained LDAP server.
LDAP users are seeded from the file at `config/ldap_seed_users.ldif`, so you can login
using either `user@example.org` or `admin@example.org` with the password 'password'.

### making an admin user
First, you'll need to start your development server and login as one of the LDAP users.  
We'll assume you logged in as `admin@example.org`
```sh
bundle exec rails c
> u = User.find_by(email: 'admin@example.org')
> u.add_role('admin')
> exit
```
If you go back and refresh your browser where `admin@example.org` is logged in, you
should now have access to the administator dashboard.


## Re-create derivatives
If you need to re-create derivatives, use these rake tasks:
1. One at a time, by id: `RAILS_ENV=production bundle exec rake derivatives:recreate_by_id[2801pg32c]`
1. Re-create derivatives for all PDF objects: `RAILS_ENV=production bundle exec rake derivatives:recreate_all_pdfs`

## Monitoring
When running this application in production, you can point monitoring systems at `/okcomputer/all` to
verify that system integrations are working as expected. Checking for the absence of the word `FAILURE`
would work. If everything is working as expected, you should see:
```
  batch_sidekiq_queue_latency: PASSED Sidekiq queue 'batch' latency at reasonable level (0) (0s)
  database: PASSED Schema version: 20171009170516 (0s)
  default: PASSED Application is running (0s)
  default_sidekiq_queue_latency: PASSED Sidekiq queue 'default' latency at reasonable level (0) (0s)
  handle_sidekiq_queue_latency: PASSED Sidekiq queue 'handle' latency at reasonable level (0) (0s)
  smtp: PASSED SMTP connection working (1s)
```
You can also check individual systems by adding their name to the end of the okcomputer url, e.g., `/okcomputer/smtp`.
See [okcomputer on github](https://github.com/sportngin/okcomputer) for more configuration options.
