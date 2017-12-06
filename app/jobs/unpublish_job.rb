##
# A job to unpublish an object
class UnpublishJob < BatchableJob
  def perform(id)
    work = ActiveFedora::Base.find(id)
    Tufts::WorkflowStatus.unpublish(work: work, current_user: workflow_user, comment: "Unpublished by #{workflow_user.display_name} #{Time.zone.now}")
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
