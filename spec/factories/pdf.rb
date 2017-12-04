require 'ffaker'

FactoryGirl.define do
  factory :pdf do
    id { ActiveFedora::Noid::Service.new.mint }
    title [FFaker::Book.title]
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    displays_in ['nowhere']
    rights_statement ['http://bostonhistory.org/photorequest.html']
    transient do
      user nil
    end

    factory :published_pdf do
      after(:create) do |work, evaluator|
        action_info = Hyrax::WorkflowActionInfo.new(work, evaluator.user)
        scope       = action_info.entity.workflow
        action      = PowerConverter
                      .convert_to_sipity_action("publish", scope: scope) { nil }

        Hyrax::Workflow::WorkflowActionService
          .run(subject: action_info,
               action:  action,
               comment: 'Published by :published_pdf factory in `after_create` hook.')
      end
    end
  end

  factory :populated_pdf, class: Pdf do
    Pdf.properties.each_value do |property|
      next if [:create_date, :modified_date, :has_model, :head, :tail].include? property.term

      if property.term == :title
        send(property.term, [FFaker::Book.title])
      elsif property.try(:multiple?)
        send(property.term, (1..4).map { FFaker::BaconIpsum.phrase })
      else
        send(property.term, FFaker::BaconIpsum.phrase)
      end
    end
  end
end
