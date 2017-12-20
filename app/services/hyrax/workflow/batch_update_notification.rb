module Hyrax
  module Workflow
    # Notify admin users of a batch import
    # @example Hyrax::Workflow::BatchUpdateNotification.new(batch).call
    class BatchUpdateNotification < MiraBatchNotification
      def batch_name
        "Metadata Update Batch #{@batch.id}"
      end
    end
  end
end
