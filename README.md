# Epigaea

[![ci](https://travis-ci.org/curationexperts/epigaea.svg?branch=master)](https://travis-ci.org/curationexperts/epigaea)
[![Coverage Status](https://coveralls.io/repos/github/curationexperts/epigaea/badge.svg?branch=master)](https://coveralls.io/github/curationexperts/epigaea?branch=master)

A [MIRA](https://github.com/TuftsUniversity/MIRA) replacement running on [Hyrax](https://github.com/samvera/hyrax) 2.0.

## Development

Get started by cloning the repository and installing the dependencies:

```sh
git clone https://github.com/curationexperts/epigaea.git
cd epigaea

cp .env.sample .env.development
bundle install
bundle exec rails db:setup
bundle exec sidekiq -d -l tmp/sidekiq.log
# open a separate session and run bundle exec rails hydra:server
```
Other services and settings required:
* MySQL
* Redis
* Path to [FITS](https://projects.iq.harvard.edu/fits/downloads) in the [Hyrax initializer](https://github.com/curationexperts/epigaea/blob/master/config/initializers/hyrax.rb)
* sidekiq as queue adapter in [application.rb](https://github.com/curationexperts/epigaea/blob/master/config/):        `config.active_job.queue_adapter = :sidekiq`

You can run CI with `rake` (or `rake ci`). Or start a server with `rake hydra:server`

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
