require_relative 'boot'

require 'rails/all'
require 'handle' # manually require handle to address gem name autoload mismatch

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Epigaea
  class Application < Rails::Application
    config.active_job.queue_adapter = :inline
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'services')
    config.autoload_paths << Rails.root.join('app', 'models', 'forms')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.to_prepare do
      Hyrax::CurationConcern.actor_factory.use Hyrax::Actors::HandleAssuranceActor
    end
  end
end
