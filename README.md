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

## Anayltics
Hyrax has some built-in integration with Google analytics. Instructions for configuration are
in the [Hyrax Management Guide](https://github.com/samvera/hyrax/wiki/Hyrax-Management-Guide#capturing-usage-and-download-counts). To track usage
using google analytics:
1. Follow the abovementioned guide and set up a google analytics account. Take note of the analytics tracking id you
are assigned and the json key you are prompted to download.
2. Put the .json key in `/opt/epigaea/shared/config` and call it `epigaea_private_key.json`
3. Populate the `.env.production` file on the production server with the relevant values from `epigaea_private_key.json`:
  ```
    export GOOGLE_ANALYTICS_ID=UA-000000000-1
    export GOOGLE_OAUTH_APP_NAME=epigaea (make up any value here)
    export GOOGLE_OAUTH_APP_VERSION=2.0 (make up any value here)
    export GOOGLE_OAUTH_PRIVATE_KEY_PATH=/opt/epigaea/config/epigaea_private_key.json
    export GOOGLE_OAUTH_PRIVATE_KEY_SECRET=[key from your .json file]
    export GOOGLE_OAUTH_CLIENT_EMAIL=epigaea@whatever.gserviceaccount.com (from your .json file)
  ```

**NOTE** The instructions above will allow you to track usage on the google analytics website.
Integration into the Hyrax admin dashboard has not yet been completed but is expected
eventually. See [Hyrax Analytics and Usage Statistics](https://github.com/samvera/hyrax/wiki/Hyrax-Management-Guide#analytics-and-usage-statistics) for more details.

## Notifications
### Sending notifications by email
All notifications use `Hyrax::MessengerService`, which in turn uses [Mailboxer](https://github.com/mailboxer/mailboxer). 
Mailboxer can be configured to send notifications by email. You can configure it to
use a different SMTP system by defining the appropriate values in a `.env.production` file. 
Required variables are:
```bash
  export ACTION_MAILER_SMTP_DELIVERY_METHOD=smtp
  export ACTION_MAILER_HOST=localhost
  export ACTION_MAILER_SMTP_ADDRESS=**YOUR DATA HERE**
  export ACTION_MAILER_PORT=**YOUR DATA HERE**
  export ACTION_MAILER_USER_NAME=**YOUR DATA HERE**
  export ACTION_MAILER_PASSWORD=**YOUR DATA HERE**
```

### Creating or editing notifications
Notifications are defined in `app/services/hyrax/workflow`. There are three kinds of notifications.
1. **MiraWorkflowNotification** -- These are subclasses of the Hyrax workflow notifications. They are triggered by Sipity workflow events, as defined in `config/workflows/mira_publication_workflow.json`. These include comment notifications, and publishing and unpublishing of single works.

2. **MiraNotification** -- These are single-item notifications which are not triggered by a SipityWorkflow event. These are primarily used for notification of single-item deposits, either via the `/contribute` form or the `Create New Work` form on the admin dashboard.

3. **MiraBatchNotification** -- These are batch notifications. They inherit some behavior from the `MiraNotification` class, but operate at a batch level instead of at an individual level. Examples include batch xml import, batch metadata update, batch publish, batch unpublish, and batch template application.
