FactoryGirl.define do
  factory :metadata_import do
    batch
    metadata_file File.open('spec/fixtures/files/mira_export.xml')
  end
end
