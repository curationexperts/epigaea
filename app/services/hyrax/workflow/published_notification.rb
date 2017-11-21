module Hyrax
  module Workflow
    # Notification of state change to "approved".
    # Should notify users with the approving role for the work's AdminSet, plus super users.
    class PublishedNotification < MiraNotification
      def workflow_recipients
        { "to" => (admins << depositor) }
      end

      def subject
        "Deposit #{title} has been published"
      end

      def message
        "#{title} (#{link_to work_id, document_url}) has been published by #{user.display_name} (#{user.user_key}).  #{comment}"
      end
    end
  end
end
