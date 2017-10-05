module Tufts
  ##
  # Handles export of metedata for groups of files.
  class MetadataExporter
    ##
    # @!attribute [rw] builder
    #   @return [XmlMetadataBuilder]
    # @!attribute [rw] ids
    #   @return [Array<String>]
    # @!attribute [rw] name
    #   @return [String]
    attr_accessor :builder, :ids, :name

    STORAGE_DIR = Pathname.new(Rails.configuration.exports_storage_dir).freeze

    ##
    # @param filename [String]
    #
    # @return [Pathname]
    def self.path_for(filename:)
      STORAGE_DIR.join(filename)
    end

    ##
    # @param ids [Array<String>]
    def initialize(ids:, builder: XmlMetadataBuilder.new, name: SecureRandom.uuid)
      @builder = builder
      @ids     = ids
      @name    = name
    end

    ##
    # @return [void]
    def cleanup!
      File.delete(path) if File.exist?(path)
    end

    ##
    # Generates an IO object with the exported data.
    #
    # @return [IO]
    def export
      populate_builder
      StringIO.new(builder.build)
    end

    ##
    # Saves the generated export to a file.
    #
    # @return [File] a file handle open for read
    # @see #export
    def export!
      populate_builder
      File.open(path, 'w') do |file|
        file.write(builder.build)
      end

      file
    end

    ##
    # @yield Yields a file when a block is given.
    # @yieldparam file [File] the file via `File#open(&block)`
    #
    # @return [File, nil] a file opened for read; nil if none exists
    def file(&block)
      File.exist?(path) ? File.open(path, 'r', &block) : nil
    end

    ##
    # @return [String]
    def filename
      "#{name}#{builder.file_extension}"
    end

    ##
    # @return [Pathname]
    def path
      self.class.path_for(filename: filename)
    end

    private

      ##
      # @private
      # @return [void]
      def populate_builder
        active_ids = ids.select { |r| ActiveFedora::Base.exists?(r) }

        ActiveFedora::Base.find(active_ids).each do |object|
          builder.add(object)
        end
      end
  end
end
