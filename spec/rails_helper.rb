unless ENV['NO_COVERAGE'] == 'true'
  require 'coveralls'
  Coveralls.wear!('rails')
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'active_fedora/cleaner'
require 'selenium-webdriver'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

FactoryGirl.register_strategy(:actor_create, ActorCreate)

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# Uses faster rack_test driver when JavaScript support not needed
Capybara.default_driver = :rack_test
Capybara::Screenshot.autosave_on_failure = false

# Adding the below to deal with random Capybara-related timeouts in CI.
# Found in this thread: https://github.com/teampoltergeist/poltergeist/issues/375
poltergeist_options = {
  js_errors: false,
  timeout: 30,
  logger: false,
  debug: false,
  phantomjs_logger: StringIO.new,
  phantomjs_options: [
    '--load-images=no',
    '--ignore-ssl-errors=yes'
  ]
}

Capybara.register_driver(:poltergeist) do |app|
  Capybara::Poltergeist::Driver.new(app, poltergeist_options)
end

# Capybara.register_driver :chrome do |app|
#  profile = Selenium::WebDriver::Chrome::Profile.new
#  Capybara::Selenium::Driver.new(app, :browser => :chrome, profile: profile)
# end

Capybara.javascript_driver = :poltergeist

Capybara.register_driver :chrome do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  profile['extensions.password_manager_enabled'] = false
  Capybara::Selenium::Driver.new(app, browser: :chrome, profile: profile)
end

Capybara.default_max_wait_time = 10

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods
  config.include ApplicationHelper, type: :view
  config.include Warden::Test::Helpers, type: :feature
  config.include OptionalExample

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    Tufts::WorkflowSetup.setup
  end

  config.before do |example|
    # Pass `:clean' to destroy objects in fedora/solr and start from scratch
    ActiveFedora::Cleaner.clean! if example.metadata[:clean]

    if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end

    Tufts::WorkflowSetup.setup if
      example.metadata[:type] == :feature || example.metadata[:workflow]
  end

  config.after(:each, type: :feature) do
    Warden.test_reset!
    Capybara.reset_sessions!
    page.driver.reset!
  end

  config.before(:context, batch: true) do
    ActiveJobStatus.store = ActiveSupport::Cache::MemoryStore.new
  end

  config.after(:each, batch: true) do
    ActiveJobStatus.store.clear
  end

  config.after do
    DatabaseCleaner.clean
  end

  ##
  # Use this example group when you want to perform jobs inline during testing.
  #
  # Limit to specific job classes with:
  #
  #   ActiveJob::Base.queue_adapter.filter = [JobClass]
  config.before(perform_enqueued: true) do
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs    = true
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true
  end

  config.after(perform_enqueued: true) do
    ActiveJob::Base.queue_adapter.enqueued_jobs  = []
    ActiveJob::Base.queue_adapter.performed_jobs = []

    ActiveJob::Base.queue_adapter.perform_enqueued_jobs    = false
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = false
  end

  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      # Choose a test framework:
      with.test_framework :rspec
      with.library :rails
    end
  end
end
