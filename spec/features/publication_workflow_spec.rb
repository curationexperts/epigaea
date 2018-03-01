require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'deposit and publication', :clean, :workflow do
  let(:depositing_user)  { FactoryGirl.create(:user) }
  let!(:publishing_user) { FactoryGirl.create(:admin) }

  let(:work) do
    FactoryGirl
      .actor_create(:image, user: depositing_user, displays_in: ['dl'], createdby: [Contribution::SELFDEP])
  end

  let(:batch_work) do
    FactoryGirl.actor_create(:image, title: ['A Batch Work'], user: depositing_user, displays_in: ['dl'])
  end

  context 'a logged in user' do
    scenario "non-admin user deposits, admin publishes", js: true do
      # All works go to the default admin set, which uses the mira_publication_workflow
      expect(work.active_workflow.name).to eq "mira_publication_workflow"

      # Upon submission, works are in the "unpublished" workflow state
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"
      expect(batch_work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"

      # A non-admin user cannot change the workflow state
      available_workflow_actions =
        Hyrax::Workflow::PermissionQuery.scope_permitted_workflow_actions_available_for_current_state(
          user: depositing_user,
          entity: work.to_sipity_entity
        ).pluck(:name)
      expect(available_workflow_actions).to be_empty

      logout
      login_as publishing_user

      # An admin user can see a work even if it is not yet published
      # in the search results
      visit("/catalog?search_field=all_fields&q=")
      expect(page).to have_content work.title.first
      # in the dashboard / all works screen
      visit("/dashboard/works")
      expect(page).to have_content work.title.first

      # Check workflow permissions for publishing user
      available_workflow_actions = Hyrax::Workflow::PermissionQuery.scope_permitted_workflow_actions_available_for_current_state(
        user: publishing_user,
        entity: work.to_sipity_entity
      ).pluck(:name)
      expect(available_workflow_actions).to contain_exactly(
        "publish",
        "batch_publish",
        "comment_only"
      )

      # Check it appears as waiting for review in the admin dashboard
      visit("/admin/workflows#under-review")
      expect(page).to have_content work.title.first
      expect(page).to have_content work.date_modified.strftime('%Y-%m-%d')

      # Check that non-selfdeposit items are excluded review
      expect(page).not_to have_content batch_work.title.first

      # The admin user approves the work, changing its status to "published"
      Tufts::WorkflowStatus.publish(work: work, current_user: publishing_user, comment: "Published in publication_workflow_spec.rb")
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"

      # Check it appears as published in the admin dashboard
      visit("/admin/workflows#under-review")
      expect(page).not_to have_content work.title.first
      visit("/admin/workflows#published")
      expect(page).to have_content work.title.first

      # The admin user approves the batch work, changing its status to "published"
      Tufts::WorkflowStatus.publish(work: batch_work, current_user: publishing_user, comment: "Published in publication_workflow_spec.rb")

      visit("/admin/workflows#published")
      expect(page).to have_content batch_work.title.first

      # The admin user comments on the work
      subject = Hyrax::WorkflowActionInfo.new(work, publishing_user)
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("comment_only", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "This is a comment")
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "published"

      # Check notifications for publishing user
      visit("/notifications")
      expect(page).to have_content "Comment about #{work.title.first}"

      # Check notifications for depositor again
      logout
      login_as depositing_user
      visit("/notifications")
      expect(page).to have_content "#{work.title.first} (#{work.id}) has been published by #{publishing_user.display_name} (#{publishing_user.user_key}). Published in publication_workflow_spec.rb"

      # After publication, an admin can unpublish a work.
      Tufts::WorkflowStatus.unpublish(work: work, current_user: publishing_user, comment: "Unpublished in publication_workflow_spec.rb")
      expect(work.to_sipity_entity.reload.workflow_state_name).to eq "unpublished"

      # Check unpublished notifications for admin user
      login_as publishing_user
      visit("/notifications")
      expect(page).to have_content "#{work.title.first} (#{work.id}) has been unpublished by #{publishing_user.display_name} (#{publishing_user.user_key}). Unpublished in publication_workflow_spec.rb"
    end
  end
end
