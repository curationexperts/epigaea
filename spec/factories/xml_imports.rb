FactoryGirl.define do
  factory :xml_import do
    metadata_file File.open('spec/fixtures/files/mira_xml.xml')
    batch
  end
end