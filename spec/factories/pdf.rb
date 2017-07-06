FactoryGirl.define do
  factory :pdf do
    id { ActiveFedora::Noid::Service.new.mint }
    title ['Test']
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end
end
