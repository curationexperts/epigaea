module Hyrax
  module Workflow
    class SelfDepositNotification < MiraNotification
      def subject
        "Deposit #{@title} awaiting publication"
      end

      def message
        "#{@title} (#{link_to @work.id, work_url}) has been deposited by #{@depositor.display_name} (#{@depositor.user_key}) and is awaiting publication."
      end
    end
  end
end
