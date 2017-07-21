require 'handle'

module Tufts
  ##
  # A handle registration service
  #
  # @example Registering a Handle to Server from Settings
  #   pdf = Pdf.create(title: ['moomin'])
  #   registrar = HandleRegistrar.new(pdf)
  #   registrar.register!
  #
  # @example Registering a Handle to a custom server connection
  #   connection = Handle::Connection.new(admin, 300, pk, pass)
  #   pdf        = Pdf.create(title: ['moomin'])
  #   registrar  = HandleRegistrar.new(pdf, connection: connection)
  #
  # @see Handle::Connection
  # @see Tufts::HandleBuilder
  class HandleRegistrar
    ##
    # A logger for handle errors
    LOGGER = Logger.new(Rails.root.join('log', 'handle.log'))

    ##
    # @param object     [ActiveFedora::Base]
    # @param connection [Handle::Connection] defaults to a connection as
    #   configured in `Settings`
    def initialize(connection: Handle::Connection.new(*connection_args),
                   builder:    HandleBuilder.new)
      @connection = connection
      @builder    = builder
    end

    ##
    # Registers a Handle with the connected handle server.
    #
    # @param builder [#build] an object that returns a handle string from `#build`
    #
    # @return [Handle::Record] the registered handle
    #
    # @raise Handle::HandleError when the handle server fails to register
    # @raise NullIdError when the object has no stable id
    def register!(object:)
      handle = @builder.build
      record = @connection.create_record(handle)
      record.add(:URL, url_for(object: object)).index = 2
      record.add(:Email, email).index = 6
      record << Handle::Field::HSAdmin.new(admin)
      record.save
      record
    rescue Handle::HandleError, NullIdError => err
      message = "Unable to register handle #{handle} for #{object.uri}\n" \
                "#{err.message}"
      LOGGER.log(nil, object.uri, message)
      raise err
    end

    class NullIdError < RuntimeError; end

    private

      ##
      # @todo make admin string configurable
      #
      # @return [String]
      def admin
        '0.NA/10427.TEST'
      end

      ##
      # @return [Array] the arguments for the default handle connection;
      def connection_args
        [:handle_admin, 300, :handle_private_key, :handle_passphrase]
      end

      ##
      # @todo make email configurable
      #
      # @return [String]
      def email
        'brian.goodmon@tufts.edu'
      end

      ##
      # @todo make the base URL configurable
      #
      # @return [String]
      #
      # @raise NullIdError
      def url_for(object:)
        unless object.id
          raise NullIdError,
                "Tried to assign a Handle to an object with nil `#id`: #{object}."
        end
        "http://dl.tufts.edu/catalog/#{object.id}"
      end
  end
end
