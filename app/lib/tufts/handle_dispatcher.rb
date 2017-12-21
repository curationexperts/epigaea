module Tufts
  ##
  # Assigns and registers handles to objects.
  #
  # @example Assigning a handle for an object (default registrar)
  #   pdf = Pdf.new(id: 'moomin')
  #
  #   dispatcher = HandleDispatcher.new
  #   dispatcher.assign_for(object: pdf)
  #   pdf.identifier # => ['hdl/some_handle']
  #
  # @example Assigning a handle with the class syntax
  #   pdf = Pdf.new(id: 'moomin')
  #
  #   HandleDispatcher.assign_for(object: pdf)
  #   pdf.identifier # => ['hdl/some_handle']
  #
  # @see Tufts::HandleRegistrar
  class HandleDispatcher
    ##
    # @!attribute [rw] registrar
    #   @return [Tufts::HandleRegistrar]
    attr_accessor :registrar

    ##
    # @param registrar [Tufts::HandleRegistrar]
    def initialize(registrar: HandleRegistrar.new)
      @registrar = registrar
    end

    class << self
      ##
      # @param attribute [Symbol] the attribute in which to store the handle. This
      #   will be overwritten during assignment
      # @param object    [AciveFedora::Base] the object to assign a handle.
      # @param registrar [Tufts::HandleRegistrar]
      #
      # @return [AciveFedora::Base] the object
      def assign_for(object:,
                     attribute: :identifier,
                     registrar: Tufts::HandleRegistrar.new)
        new(registrar: registrar)
          .assign_for(object: object, attribute: attribute)
      end

      ##
      # @param attribute [Symbol] the attribute in which to store the handle. This
      #   will be overwritten during assignment
      # @param object    [AciveFedora::Base] the object to assign a handle.
      # @param registrar [Tufts::HandleRegistrar]
      #
      # @return [AciveFedora::Base] the object
      def assign_for!(object:,
                      attribute: :identifier,
                      registrar: Tufts::HandleRegistrar.new)
        new(registrar: registrar)
          .assign_for!(object: object, attribute: attribute)
      end
    end

    ##
    # Assigns a handle to the object.
    #
    # This involves two steps:
    #   - Registering the handle with the handle server via `registrar`.
    #   - Storing the new handle on the object, in the provided `attribute`.
    #
    # @note the attribute for handle storage must be multi-valued, and will be
    #   overwritten during assignment.
    #
    # @param attribute [Symbol] the attribute in which to store the handle. This
    #   will be overwritten during assignment
    # @param object    [AciveFedora::Base] the object to assign a handle.
    #
    # @return [AciveFedora::Base] the object
    def assign_for(object:, attribute: :identifier)
      record = registrar.register!(object: object)
      object.public_send("#{attribute}=".to_sym, handle_values(record: record))
      object
    end

    ##
    # Assigns a handle and saves the object.
    #
    # @see #assign_for
    def assign_for!(object:, attribute: :identifier)
      assign_for(object: object, attribute: attribute).save!
      object
    end

    private

      ##
      # @private
      # @param [#handle] record
      # @return [Array<String>]
      def handle_values(record:)
        ["http://hdl.handle.net/#{record.handle}"]
      end
  end
end
