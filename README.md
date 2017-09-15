# Epigaea

![ci](https://travis-ci.org/curationexperts/epigaea.svg?branch=master)

A [MIRA](https://github.com/TuftsUniversity/MIRA) replacement running on [Hyrax](https://github.com/samvera/hyrax) 2.0.

## Development

Get started by cloning the repository and installing the dependencies:

```sh
git clone https://github.com/curationexperts/epigaea.git
cd epigaea

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
