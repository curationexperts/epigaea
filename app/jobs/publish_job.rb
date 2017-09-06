##
# A job to mark an existing object published.
class PublishJob < BatchableJob
  def perform(id)
    model = ActiveFedora::Base.find(id)
    model.mark_published
    model.save
  end
end
