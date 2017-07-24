module Tufts
  class Template
    ##
    # @!attribute changeset [rw]
    #   @return [ActiveFedora::ChangeSet]
    # @!attribute name [rw]
    #   @return [String] the name of the template
    attr_accessor :changeset, :name

    STORAGE_DIR = Pathname.new(Rails.configuration.templates_storage_dir).freeze

    ##
    # @param changeset [ActiveFedora::ChangeSet]
    # @param name      [String]
    def initialize(name:, changeset: NullChangeSet.new)
      @name      = name
      @changeset = changeset
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
      ''
    end

    private

      def path
        STORAGE_DIR.join(name)
      end
  end
end
