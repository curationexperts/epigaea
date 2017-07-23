##
# A job to update handle metadata with the handle server.
#
# @example
#   object = Pdf.create(title: ['Moomin'])
#   HandleUpdateJob.perform_later(object)
#
# @see ActiveJob::Base, HandleRegistrar#update!
class HandleUpdateJob < ApplicationJob
  queue_as :handle

  rescue_from(Handle::HandleError) do
    Tufts::HandleRegistrar::LOGGER
      .log(nil, object.id, "Retrying Handle update for #{object.id}")
    retry_job wait: 30.seconds, queue: :handle
  end

  ##
  # @param object [ActiveFedora::Base]
  def perform(object)
    Tufts::HandleRegistrar.new.update!(handle: object.identifier.first, object: object)
  end
end
