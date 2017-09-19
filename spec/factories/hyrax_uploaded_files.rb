FactoryGirl.define do
  factory :hyrax_uploaded_file, class: Hyrax::UploadedFile do
    user
    file File.open('spec/fixtures/files/pdf-sample.pdf')
  end
end
