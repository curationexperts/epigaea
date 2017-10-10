##
# A job to mark an existing object published.
class PublishJob < BatchableJob
  def perform(id)
    work = ActiveFedora::Base.find(id)
    subject = Hyrax::WorkflowActionInfo.new(work, workflow_user)
    sipity_workflow_action = PowerConverter.convert_to_sipity_action("publish", scope: subject.entity.workflow) { nil }
    Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "Published by #{workflow_user.display_name} #{Time.zone.now}")
  end

  # The workflow needs the action to be performed by a user with admin rights
  # @return [::User] an admin user to perform the batch publish operation
  def workflow_user
    ::User.find_or_create_by(email: 'batch_workflow_user@example.com') do |user|
      user.display_name = "Batch Publish Job"
      user.password = SecureRandom.uuid
      admin_role = Role.where(name: 'admin').first_or_create
      user.roles << admin_role
    end
  end
end
