require_relative 'boot'

require 'rails/all'
require 'handle' # manually require handle to address gem name autoload mismatch

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Epigaea
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'services')
    config.autoload_paths << Rails.root.join('app', 'models', 'forms')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.to_prepare do
      factory = Hyrax::CurationConcern.actor_factory
      factory.use(Hyrax::Actors::HandleAssuranceActor)
      factory.swap(Hyrax::Actors::CreateWithFilesActor, Hyrax::Actors::CreateWithFilesAndPassTypesActor)

      # Hyrax's instructions don't work
      # https://github.com/samvera/hyrax/blame/a992e37fba805665e1587f40870bde5cd3826b3f/app/services/hyrax/curation_concern.rb#L3-L18
      # we'll force setting the stack instead
      Hyrax::CurationConcern
        .instance_variable_set(:@work_middleware_stack,
                               factory.build(Hyrax::Actors::Terminator.new))
    end
  end
end
Rails.application.routes.default_url_options[:host] = ENV["RAILS_HOST"]
