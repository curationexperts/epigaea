Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Mail Settings
  config.action_mailer.default_url_options = { host: ENV["ACTION_MAILER_HOST"] }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = ENV['ACTION_MAILER_SMTP_DELIVERY_METHOD'].to_sym
  config.action_mailer.smtp_settings = {
    address: ENV['ACTION_MAILER_SMTP_ADDRESS'],
    port: ENV['ACTION_MAILER_PORT'],
    user_name: ENV['ACTION_MAILER_USER_NAME'],
    password: ENV['ACTION_MAILER_PASSWORD'],
    enable_starttls_auto: true
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.active_job.queue_adapter = :sidekiq

  # Configure the drafts strorage directory
  config.drafts_storage_dir    = Rails.root.join('tmp', 'drafts')
  config.exports_storage_dir   = Rails.root.join('tmp', 'exports')
  config.templates_storage_dir = Rails.root.join('tmp', 'templates')
  config.metadata_upload_dir   = Rails.root.join('tmp', 'metadata')
end
