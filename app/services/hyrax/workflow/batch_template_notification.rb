module Hyrax
  module Workflow
    # Notify admin users that a template has been applied to a batch
    class BatchTemplateNotification < MiraBatchNotification
      # @param [Batch] batch
      # @param [String] template_name
      def initialize(batch, template_name)
        @batch = batch
        @template_name = template_name
        @user = ensure_user(batch)
      end

      def batch_name
        "Template Batch #{@batch.id}"
      end

      def message
        "Template '#{@template_name}' was applied to #{link_to batch_name, batch_url} by #{@user.display_name} (#{@user.user_key}) at #{@batch.created_at}."
      end
    end
  end
end
