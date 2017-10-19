# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'
require 'active_fedora/cleaner'
include Warden::Test::Helpers

RSpec.feature 'deposit and publication' do
  let(:depositing_user) { FactoryGirl.create(:user) }
  let(:publishing_user) { FactoryGirl.create(:admin) }
  let(:work) { FactoryGirl.create(:image) }
  context 'a logged in user' do
    before do
      Image.delete_all
      allow(CharacterizeJob).to receive(:perform_later) # There is no fits installed on travis-ci
      publishing_user # Make sure publishing user exists before the work is submitted
      current_ability = ::Ability.new(depositing_user)
      attributes = {}
      env = Hyrax::Actors::Environment.new(work, current_ability, attributes)
      Hyrax::CurationConcern.actor.create(env)
    end
    scenario "non-admin user deposits, admin publishes", js: true do
      # All works go to the default admin set, which uses the mira_publication_workflow
      expect(work.active_workflow.name).to eq "mira_publication_workflow"

      # Upon submission, works are in the "pending review" workflow state
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"

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
      visit("/notifications")
      expect(page).to have_content "#{work.title.first} (#{work.id}) has been deposited by #{depositing_user.display_name} (#{depositing_user.user_key}) and is awaiting publication."

      logout
      login_as publishing_user

      # An admin user can see a work even if it is not yet published
      # in the search results
      visit("/catalog?search_field=all_fields&q=")
      expect(page).to have_content work.title.first

      # Check notifications for publishing user
      visit("/notifications")
      expect(page).to have_content "#{work.title.first} (#{work.id}) has been deposited by #{depositing_user.display_name} (#{depositing_user.user_key}) and is awaiting publication."

      # Check workflow permissions for publishing user
      available_workflow_actions = Hyrax::Workflow::PermissionQuery.scope_permitted_workflow_actions_available_for_current_state(
        user: publishing_user,
        entity: work.to_sipity_entity
      ).pluck(:name)
      expect(available_workflow_actions).to contain_exactly(
        "publish",
        "comment_only"
      )

      # Check it appears as waiting for review in the admin dashboard
      visit("/admin/workflows#under-review")
      expect(page).to have_content work.title.first

      # The admin user approves the work, changing its status to "published"
      subject = Hyrax::WorkflowActionInfo.new(work, publishing_user)
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("publish", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "Published in publication_workflow_spec.rb")
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"

      # Check it appears as published in the admin dashboard
      visit("/admin/workflows#under-review")
      expect(page).not_to have_content work.title.first
      visit("/admin/workflows#published")
      expect(page).to have_content work.title.first

      # Check notifications for publishing user
      visit("/notifications")
      expect(page).to have_content "#{work.title.first} (#{work.id}) has been published by #{publishing_user.display_name} (#{publishing_user.user_key}). Published in publication_workflow_spec.rb"

      # Check notifications for depositor again
      logout
      login_as depositing_user
      visit("/notifications")
      expect(page).to have_content "#{work.title.first} (#{work.id}) has been published by #{publishing_user.display_name} (#{publishing_user.user_key}). Published in publication_workflow_spec.rb"

      # After publication, works are visible to the public
      # Visit the ETD as a public user. It should be visible.
      logout
      visit("/concern/images/#{work.id}")
      expect(page).not_to have_content "The work is not currently available"

      # After publication, an admin can unpublish a work.
      subject = Hyrax::WorkflowActionInfo.new(work, publishing_user)
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("unpublish", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "Unpublished in publication_workflow_spec.rb")
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"

      # Check unpublished notifications for admin user
      login_as publishing_user
      visit("/notifications")
      expect(page).to have_content "#{work.title.first} (#{work.id}) has been unpublished by #{publishing_user.display_name} (#{publishing_user.user_key}). Unpublished in publication_workflow_spec.rb"
      logout

      # After being unpublished, the work will no longer be visible to the public.
      visit("/concern/images/#{work.id}")
      expect(page).to have_content "The work is not currently available"
    end
  end
end
