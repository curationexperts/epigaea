FactoryGirl.define do
  factory :image do
    id { ActiveFedora::Noid::Service.new.mint }
    title ["Image: #{FFaker::Movie.title}"]
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC

    transient do
      user nil
    end
  end
end
