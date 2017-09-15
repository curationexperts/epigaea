module Hyrax
  module Workflow
    class SelfDepositNotification < MiraNotification
      def workflow_recipients
        { "to" => (admins << depositor) }
      end

      private

        def subject
          "Deposit #{title} awaiting publication"
        end

        def message
          "#{title} (#{link_to work_id, document_path}) has been deposited by #{depositor.display_name} (#{depositor.user_key}) and is awaiting publication."
        end
    end
  end
end
