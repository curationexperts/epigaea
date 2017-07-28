##
# A job to register handles and save it to the object.
#
# @example
#   object = Pdf.create(title: ['Moomin'])
#   HandleRegisterJob.perform_later(object)
#
# @see ActiveJob::Base, HandleDispatcher.assign_for!
class HandleRegisterJob < ApplicationJob
  queue_as :handle

  rescue_from(Handle::HandleError) do
    Tufts::HandleRegistrar::LOGGER
      .log(nil, object.id, "Retrying Handle registration for #{object.id}")
    retry_job wait: 30.seconds, queue: :handle
  end

  ##
  # @param object [ActiveFedora::Base]
  def perform(object)
    Tufts::HandleDispatcher.assign_for!(object: object)
    object.save!
  end
end
