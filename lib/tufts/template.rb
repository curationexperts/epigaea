module Tufts
  class Template
    ##
    # @!attribute changeset [rw]
    #   @return [ActiveFedora::ChangeSet]
    # @!attribute name [rw]
    #   @return [String] the name of the template
    # @!attribute [rw] serializer
    #   @return [Tufts::ChangesetSerializer]
    attr_accessor :changeset, :name, :serializer

    STORAGE_DIR = Pathname.new(Rails.configuration.templates_storage_dir).freeze
    TEMP_URI    = RDF::URI.intern('http://dl.tufts.edu/ns/TEMPORARY_URI').freeze

    ##
    # @param changeset [ActiveFedora::ChangeSet]
    # @param name      [String]
    def initialize(name:, changeset: NullChangeSet.new)
      @name       = name
      @changeset  = changeset
      @serializer = Tufts::ChangesetSerializer.new
    end

    class << self
      ##
      # @return [Enumerable<Template>] all the available templates
      def all
        Enumerator.new do |yielder|
          STORAGE_DIR.each_entry do |file|
            file = file.to_s
            next if file.start_with?('.') # skip hidden files and ./..
            yielder << new(name: file).load
          end
        end
      end

      ##
      # @param name [String]
      #
      # @return [Template] the template matching the parameters given
      # @raise [RuntimeError] when no template is found
      def for(name:)
        all.find { |template| template.name == name } ||
          raise("No Template found for #{name}.")
      end
    end

    ##
    # @param model [ActiveFedora::Base]
    #
    # @return [void]
    def apply_to(model:)
      changeset_for_model = load_with_model(model)

      Tufts::ChangesetOverwriteStrategy
        .new(model: model, changeset: changeset_for_model)
        .apply
    end

    ##
    # @return [Template] self
    def delete
      File.delete(path) if exists?
    end

    ##
    # @return [Boolean]
    def exists?
      File.exist? path
    end

    ##
    # @return [Template] self
    def load
      self.changeset = load_with_model
      self
    end

    ##
    # Saves the template to disk
    #
    # @example
    #   template = Template.new(name: 'My Template')
    #   template.exists # => false
    #
    #   template.save
    #   template.exists # => true
    #
    # @return [Template] self
    def save
      File.open(path, 'w+') { |f| f.write(serialize) }
      self
    end
    alias save! save

    ##
    # @return [String]
    def serialize
      serializer.serialize(changeset: changeset, subject: TEMP_URI)
    end

    private

      def load_with_model(load_model = nil)
        if exists?
          unless load_model
            load_model = GenericObject.new
            load_model.resource.set_subject!(TEMP_URI)
          end

          File.open(path) do |f|
            return serializer.deserialize(f.read, model: load_model)
          end
        else
          NullChangeSet.new
        end
      end

      def path
        STORAGE_DIR.join(name)
      end
  end
end
