FactoryGirl.define do
  factory :template, class: Tufts::Template do
    name 'Moomin Template'

    initialize_with { new(name: name) }
  end
end
