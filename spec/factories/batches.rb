FactoryGirl.define do
  factory :batch do
    association :batchable, factory: :template_update
    user
    ids ['abc', '123']
  end
end
