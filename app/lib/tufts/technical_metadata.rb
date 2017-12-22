module Tufts
  # A class to generate an XML document that contains all the technical
  # metadata that has been persisted in Fedora after characterization
  # with FITS
  #
  # It does this by loading an ActiveFedora::Base object for a work
  # and then iterating through the FileSets on the work. It then
  # creates an Nokogiri::XML::Builder object with values from the
  # FileSet member's characterization proxy
  #
  # @example
  # object = ActiveFedora::Base.find('mnvmbnvb')
  # tm = Tufts::TechnicalMetadata.new(object)
  # tm.to_s
  #
  class TechnicalMetadata
    ##
    # @!attribute base, builder [r]
    # @!attribute file_set [rw]
    attr_reader :base, :builder
    ##
    # @param work [Object]
    def initialize(work)
      @base = work
      @builder = xml_builder
    end

    # @return [String]
    def to_s
      @builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION | Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS).strip
    end

    # @return [Object]
    def to_xml
      @builder.to_xml
    end

    private

      # @return [Nokogiri::XML::Builder]
      def xml_builder # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        @builder = Nokogiri::XML::Builder.new do |xml| # rubocop:disable Metrics/BlockLength
          xml.technicalMetadata do # rubocop:disable Metrics/BlockLength
            @base.file_sets.each do |fs| # rubocop:disable Metrics/BlockLength
              @file_set = fs
              proxy = fs.characterization_proxy
              xml.file do # rubocop:disable Metrics/BlockLength
                xml.fits_version = proxy.fits_version[0] if proxy.fits_version[0]
                xml.format_label = proxy.format_label[0] if proxy.format_label[0]
                xml.mime_type = proxy.mime_type if proxy.mime_type
                xml.file_size = proxy.file_size[0] if proxy.file_size[0]
                xml.file_name = proxy.file_name[0] if proxy.file_name[0]
                xml.original_checksum = proxy.original_checksum[0] if proxy.original_checksum[0]
                xml.date_created = proxy.date_created[0] if proxy.date_created[0]
                xml.well_formed = proxy.well_formed[0] if proxy.well_formed[0]
                xml.valid = proxy.valid[0] if proxy.valid[0]
                xml.file_title = proxy.file_title[0] if proxy.file_title[0]
                xml.page_count = proxy.page_count[0] if proxy.page_count[0]
                xml.word_count = proxy.word_count[0] if proxy.word_count[0]
                xml.character_count = proxy.character_count[0] if proxy.character_count[0]
                xml.paragraph_count = proxy.paragraph_count[0] if proxy.paragraph_count[0]
                xml.line_count = proxy.line_count[0] if proxy.line_count[0]
                xml.table_count = proxy.table_count[0] if proxy.table_count[0]
                xml.byte_order = proxy.byte_order[0] if proxy.byte_order[0]
                xml.compression = proxy.compression[0] if proxy.compression[0]
                xml.width = proxy.width[0] if proxy.width[0]
                xml.height = proxy.height[0] if proxy.height[0]
                xml.color_space = proxy.color_space[0] if proxy.color_space[0]
                xml.profile_name = proxy.profile_name[0] if proxy.profile_name[0]
                xml.profile_version = proxy.profile_version[0] if proxy.profile_version[0]
                xml.orientation = proxy.orientation[0] if proxy.orientation[0]
                xml.color_map = proxy.color_map[0] if proxy.color_map[0]
                xml.image_producer = proxy.image_producer[0] if proxy.image_producer[0]
                xml.capture_device = proxy.capture_device[0] if proxy.capture_device[0]
                xml.scanning_software = proxy.scanning_software[0] if proxy.scanning_software[0]
                xml.exif_version = proxy.exif_version[0] if proxy.exif_version[0]
                xml.gps_timestamp = proxy.gps_timestamp[0] if proxy.gps_timestamp[0]
                xml.latitude = proxy.latitude[0] if proxy.latitude[0]
                xml.longitude = proxy.longitude[0] if proxy.longitude[0]
                xml.character_set = proxy.character_set[0] if proxy.character_set[0]
                xml.markup_basis = proxy.markup_basis[0] if proxy.markup_basis[0]
                xml.markup_language = proxy.markup_language[0] if proxy.markup_language[0]
                xml.bit_depth = proxy.bit_depth[0] if proxy.bit_depth[0]
                xml.channels = proxy.channels[0] if proxy.channels[0]
                xml.data_format = proxy.data_format[0] if proxy.data_format[0]
                xml.offset = proxy.offset[0] if proxy.offset[0]
                xml.frame_rate = proxy.frame_rate[0] if proxy.frame_rate[0]
              end
            end
          end
        end
      end
  end
end
