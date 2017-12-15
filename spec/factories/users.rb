require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "#{n}#{FFaker::Internet.email}"
    end
    sequence :username do |n|
      "#{FFaker::Internet.user_name}#{n}"
    end
    password 'password'
    display_name FFaker::Name.name
    after(:create) { |user| user.remove_role(:admin) }

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
