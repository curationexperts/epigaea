module Hyrax
  module Workflow
    # Notify admin users of a batch import
    # @example Hyrax::Workflow::BatchUnpublishNotification.new(batch).call
    class BatchUnpublishNotification < MiraBatchNotification
      def batch_name
        "Unpublished Batch #{@batch.id}"
      end
    end
  end
end
