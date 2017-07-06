FactoryGirl.define do
  factory :image do
    id { ActiveFedora::Noid::Service.new.mint }
    title ['Test']
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end
end
