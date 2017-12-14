##
# A job to revert a draft for an object
class RevertJob < BatchableJob
  def perform(id)
    work = ActiveFedora::Base.find(id)
    work.delete_draft
  end
end
