class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'

  protect_from_forgery with: :exception

  # Since we only expect to ever use English, set the locale to :en
  # without having it passed in via the URL. Then, ensure locale: I18n.locale
  # is not set in default_url_options
  before_action :set_locale
  def set_locale
    I18n.locale = :en
  end

  def default_url_options
    {}
  end
end
