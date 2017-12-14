FactoryGirl.define do
  factory :hyrax_uploaded_file, class: Hyrax::UploadedFile do
    user
    file File.open('spec/fixtures/files/pdf-sample.pdf')

    factory :second_uploaded_file do
      file File.open('spec/fixtures/files/2.pdf')
    end
  end
end
