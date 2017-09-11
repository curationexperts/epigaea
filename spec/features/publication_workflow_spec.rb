# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'
require 'active_fedora/cleaner'
require 'tufts/workflow_setup'
include Warden::Test::Helpers

RSpec.feature 'deposit and publication' do
  let(:depositing_user) { FactoryGirl.create(:user) }
  let(:approving_user) { FactoryGirl.create(:admin) }
  let(:work) { FactoryGirl.create(:image) }
  context 'a logged in user' do
    before do
      allow(CharacterizeJob).to receive(:perform_later) # There is no fits installed on travis-ci
      Tufts::WorkflowSetup.new.set_default_workflow
      current_ability = ::Ability.new(depositing_user)
      attributes = {}
      env = Hyrax::Actors::Environment.new(work, current_ability, attributes)
      Hyrax::CurationConcern.actor.create(env)
    end
    scenario "non-admin user deposits, admin publishes" do
      # All works go to the default admin set, which uses the mira_publication_workflow
      expect(work.active_workflow.name).to eq "mira_publication_workflow"

      # Upon submission, works are in the "pending review" workflow state
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "pending_review"

      # Upon submission, works are not visible to the public
      visit("/concern/images/#{work.id}")
      expect(page).to have_content "The work is not currently available because it has not yet completed the approval process"

      # A non-admin user cannot change the workflow state
      available_workflow_actions =
        Hyrax::Workflow::PermissionQuery.scope_permitted_workflow_actions_available_for_current_state(
          user: depositing_user,
          entity: work.to_sipity_entity
        ).pluck(:name)
      expect(available_workflow_actions).to be_empty

      # Check notifications for depositing user
      login_as depositing_user
      visit("/notifications?locale=en")
      expect(page).to have_content "Deposit needs review #{work.title.first} (#{work.id}) was deposited by #{depositing_user.email} and is awaiting approval"

      # Check notifications for approving user
      logout
      login_as approving_user
      visit("/notifications?locale=en")
      # expect(page).to have_content "#{work.title.first} (#{work.id}) was deposited by #{depositing_user.display_name} and is awaiting approval."
      # expect(page).to have_content "Deposit needs review #{work.title.first} (#{work.id}) was deposited by #{depositing_user.email} and is awaiting approval"

      # Check workflow permissions for approving user
      available_workflow_actions = Hyrax::Workflow::PermissionQuery.scope_permitted_workflow_actions_available_for_current_state(
        user: approving_user,
        entity: work.to_sipity_entity
      ).pluck(:name)
      expect(available_workflow_actions).to contain_exactly(
        # "mark_reviewed",
        "approve",
        "request_changes",
        "comment_only"
      )

      # The admin user approves the work, changing its status to "published"
      subject = Hyrax::WorkflowActionInfo.new(work, approving_user)
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("approve", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "Approved in publication_workflow_spec.rb")
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"

      #     # Check notifications for approving user
      #     visit("/notifications?locale=en")
      #     expect(page).to have_content "#{etd.title.first} (#{etd.id}) has been approved by"

      # Check notifications for depositor again
      logout
      login_as depositing_user
      visit("/notifications?locale=en")
      expect(page).to have_content "#{work.title.first} (#{work.id}) was approved by #{approving_user.email}. Approved in publication_workflow_spec.rb"

      # After publication, works are visible to the public
      # Visit the ETD as a public user. It should be visible.
      logout
      visit("/concern/images/#{work.id}")
      expect(page).not_to have_content "The work is not currently available"
    end
  end
end
