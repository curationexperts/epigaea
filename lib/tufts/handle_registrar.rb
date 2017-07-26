require 'handle'

module Tufts
  ##
  # A handle registration service
  #
  # @example Registering a Handle to Server from Settings
  #   pdf = Pdf.create(title: ['moomin'])
  #   registrar = HandleRegistrar.new
  #   registrar.register(object: pdf)
  #
  # @example Registering a Handle to a custom server connection
  #   connection = Handle::Connection.new(admin, 300, pk, pass)
  #   pdf        = Pdf.create(title: ['moomin'])
  #   registrar  = HandleRegistrar.new(connection: connection)
  #   registrar.register!(object: pdf)
  #
  # @see Handle::Connection
  # @see Tufts::HandleBuilder
  class HandleRegistrar
    ##
    # A logger for handle errors
    LOGGER = Logger.new(Rails.root.join('log', 'handle.log'))

    ##
    # @param object     [#id]
    # @param connection [Handle::Connection] defaults to a connection as
    #   configured in `Settings`
    def initialize(connection: Handle::Connection.new(*connection_args),
                   builder:    HandleBuilder.new(prefix: config['prefix']))
      @connection = connection
      @builder    = builder
    end

    ##
    # @return [Hash<String, Object>]
    def config
      Rails.application.config_for(:handle)
    end

    ##
    # Registers a Handle with the connected handle server.
    #
    # @param builder [#build] an object that returns a handle string from `#build`
    #
    # @return [Handle::Record] the registered handle
    #
    # @raise [Handle::HandleError] when the handle server fails to register
    # @raise [NullIdError] when the object has no stable id
    def register!(object:)
      check_id!(object)
      handle = @builder.build(hint: object.id)
      record = @connection.create_record(handle)
      update_record(object: object, record: record)
      record.save
      record
    rescue Handle::HandleError, NullIdError => err
      message = "Unable to register handle #{handle} for #{object.id}\n" \
                "#{err.message}"
      LOGGER.log(nil, object.id, message)
      raise err
    end

    ##
    # Updates a the record for the given handle using the details of a given
    # object.
    #
    # @note This does not attempt to validate that the object and the handle
    #   are correctly paired. Clients should take care that updates are
    #   intended.
    #
    # @param handle [String]
    # @param object [#id]
    #
    # @return [Handle::Record] the updated handle record
    #
    # @raise [Handle::NotFound] if the Conncetion returns not found
    # @raise [Handle::HandleError] for other server errors
    # @raise [NullIdError] when the object has no stable id
    def update!(handle:, object:)
      check_id!(object)
      record = @connection.resolve_handle(handle)
      old_fields = record.to_a.dup
      update_record(object: object, record: record)
      record.save unless record.to_a == old_fields
      record
    end

    ##
    # Aligns the fields of `record` with those of `object`.
    #
    # @param object [#id]
    # @param record [Handle::Record]
    # @return [void]
    def update_record(object:, record:)
      record.fields.delete_if do |field|
        ['URL', 'EMAIL', 'HS_ADMIN'].include?(field.class.value_type)
      end

      record.add(:URL, url_for(object: object)).index = 2
      record.add(:Email, config['email']).index = 6
      record << Handle::Field::HSAdmin.new(config['admin'])
    end

    class NullIdError < RuntimeError; end

    private

      ##
      # @return [Array] the arguments for the default handle connection;
      def connection_args
        c = config

        if c.fetch('secret_key', false)
          [c['admin'], c['index'], c['secret_key']]
        else
          [c['admin'], c['index'], c['private_key'], c['passphrase']]
        end
      end

      ##
      # @return [String]
      def url_for(object:)
        "#{config['base_url']}#{object.id}"
      end

      ##
      # @param object [#id]
      # @return [void]
      # @raise NullIdError unless object's #id is truthy
      def check_id!(object)
        return if object.id
        raise NullIdError, 'Tried to assign a Handle to an object ' \
                           "with nil `#id`: #{object}."
      end
  end
end
