FactoryGirl.define do
  factory :collection do
    title ['A moomin collection']
    ead ['an_ead_id']

    transient do
      user { create(:admin) }
    end

    after(:build) do |collection, evaluator|
      collection.apply_depositor_metadata(evaluator.user.user_key) if evaluator.user
    end
  end
end
