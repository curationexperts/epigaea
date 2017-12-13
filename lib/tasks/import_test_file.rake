if Rails.env == 'development'
  require 'fileutils'
  require 'nokogiri'
  require 'ffaker'

  namespace :import do
    desc "Create a file for testing bulk import -- defaults to 5 records."
    task :make_test_file, [:count] => :environment do |_t, args|
      args.with_defaults(count: "5")
      puts "Making an import file with #{args[:count]} entries"
      dir_path = make_directory(args[:count])
      import_file = create_import_file(args[:count])
      File.open("#{dir_path}/#{args[:count]}_sample.xml", 'w') { |file| file.write(import_file) }
      copy_files(args[:count])
      puts "See #{dir_path}/#{args[:count]}_sample.xml"
    end

    def make_directory(count)
      dir_path = Rails.root.join('tmp', 'import_testing', count)
      FileUtils.mkdir_p dir_path
      dir_path
    end

    def copy_files(count)
      count.to_i.times do |i|
        FileUtils.cp Rails.root.join('spec', 'fixtures', 'files', 'pdf-sample.pdf'), Rails.root.join('tmp', 'import_testing', count, "pdf_sample#{i}.pdf")
      end
    end

    def create_import_file(number_of_records)
      namespace = define_namespace
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.OAIPMH(namespace) do
          xml.ListRecords do
            number_of_records.to_i.times do |i|
              xml.record do
                xml.metadata do
                  xml.mira_import do
                    xml.send("tufts:filename", "pdf_sample#{i}.pdf")
                    xml.send("tufts:visibility", "open")
                    xml.send("model:hasModel", "Pdf")
                    xml.send("dc:title", "Sample Data: #{FFaker::Book.title}")
                    xml.send("tufts:displays_in", "dl")
                  end
                end
              end
            end
          end
        end
      end
      CGI.unescapeHTML(builder.to_xml)
    end

    def define_namespace
      {
        "xsi:schemaLocation" => "http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd",
        "xmlns" => "http://www.openarchives.org/OAI/2.0/",
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:model" => "info:fedora/fedora-system:def/model#",
        "xmlns:fcrepo4" => "http://fedora.info/definitions/v4/repository#",
        "xmlns:iana" => "http://www.iana.org/assignments/relation/",
        "xmlns:marcrelators" => "http://id.loc.gov/vocabulary/relators/",
        "xmlns:dc" => "http://purl.org/dc/terms/",
        "xmlns:fedoraresourcestatus" => "http://fedora.info/definitions/1/0/access/ObjState#",
        "xmlns:scholarsphere" => "http://scholarsphere.psu.edu/ns",
        "xmlns:opaquehydra" => "http://opaquenamespace.org/ns/hydra/",
        "xmlns:bibframe" => "http://bibframe.org/vocab/",
        "xmlns:dc11" => "http://purl.org/dc/elements/1.1/",
        "xmlns:ebucore" => "http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#",
        "xmlns:premis" => "http://www.loc.gov/premis/rdf/v1#",
        "xmlns:mads" => "http://www.loc.gov/mads/rdf/v1#",
        "xmlns:tufts" => "http://dl.tufts.edu/terms#",
        "xmlns:edm" => "http://www.europeana.eu/schemas/edm/",
        "xmlns:foaf" => "http://xmlns.com/foaf/0.1/",
        "xmlns:rdfs" => "http://www.w3.org/2000/01/rdf-schema#"
      }
    end
  end
end
