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
      @builder.doc.root.to_s
    end

    # @return [Object]
    def to_xml
      @builder.to_xml
    end

    private

      # @return [Nokogiri::XML::Builder]
      def xml_builder # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        @builder = Nokogiri::XML::Builder.new do |xml| # rubocop:disable Metrics/BlockLength
          xml.technicalMetadata do # rubocop:disable Metrics/BlockLength
            @base.file_sets.each do |fs| # rubocop:disable Metrics/BlockLength
              @file_set = fs
              xml.file do
                xml.byte_order = fs.characterization_proxy.byte_order[0]
                xml.compression  = fs.characterization_proxy.compression[0]
                xml.height       = fs.characterization_proxy.height[0]
                xml.color_space  = fs.characterization_proxy.color_space[0]
                xml.profile_name = fs.characterization_proxy.profile_name[0]
                xml.profile_version = fs.characterization_proxy.profile_version[0]
                xml.orientation = fs.characterization_proxy.orientation[0]
                xml.color_map = fs.characterization_proxy.color_map[0]
                xml.image_producer = fs.characterization_proxy.image_producer[0]
                xml.capture_device = fs.characterization_proxy.capture_device[0]
                xml.scanning_software = fs.characterization_proxy.scanning_software[0]
                xml.gps_timestamp = fs.characterization_proxy.gps_timestamp[0]
                xml.latitude = fs.characterization_proxy.latitude[0]
                xml.longitude = fs.characterization_proxy.longitude[0]
                xml.file_title = fs.characterization_proxy.file_title[0]
                xml.page_count = fs.characterization_proxy.page_count[0]
                xml.duration = fs.characterization_proxy.duration[0]
                xml.sample_rate = fs.characterization_proxy.sample_rate[0]
                xml.format_label = fs.characterization_proxy.format_label[0]
                xml.file_size = fs.characterization_proxy.file_size[0]
                xml.file_name = fs.characterization_proxy.file_name[0]
                xml.well_formed = fs.characterization_proxy.well_formed[0]
                xml.original_checksum = fs.characterization_proxy.original_checksum[0]
                xml.mime_type = fs.characterization_proxy.mime_type[0]
                xml.size = fs.characterization_proxy.size[0]
              end
            end
          end
        end
      end
  end
end
