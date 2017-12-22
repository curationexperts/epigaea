##
# A job to purge works in a batch
class PurgeJob < BatchableJob
  def perform(id)
    work = ActiveFedora::Base.find(id)
    work.delete_draft
    work.destroy
  end
end
