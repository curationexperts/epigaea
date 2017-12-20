module Hyrax
  module Workflow
    # Notify admin users of a batch import
    # @example Hyrax::Workflow::BatchImportNotification.new(batch).call
    class BatchImportNotification < MiraBatchNotification
      def batch_name
        "XML Import Batch #{@batch.id}"
      end
    end
  end
end
