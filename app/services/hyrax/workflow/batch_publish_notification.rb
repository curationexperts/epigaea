module Hyrax
  module Workflow
    # Notify admin users of a batch import
    # @example Hyrax::Workflow::BatchPublishNotification.new(batch).call
    class BatchPublishNotification < MiraBatchNotification
      def batch_name
        "Publication Batch #{@batch.id}"
      end
    end
  end
end
