##
# A job to mark an existing object published.
class PublishJob < BatchableJob
  def perform(id)
    work = ActiveFedora::Base.find(id)
    Tufts::WorkflowStatus.publish(work: work, current_user: ::User.batch_user, comment: "Published by PublishJob #{Time.zone.now}")
  end
end
