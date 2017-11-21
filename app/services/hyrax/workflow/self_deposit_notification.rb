module Hyrax
  module Workflow
    class SelfDepositNotification < MiraNotification
      def workflow_recipients
        { "to" => (admins << depositor) }
      end

      def subject
        "Deposit #{title} awaiting publication"
      end

      def message
        "#{title} (#{link_to work_id, document_url}) has been deposited by #{depositor.display_name} (#{depositor.user_key}) and is awaiting publication."
      end
    end
  end
end
