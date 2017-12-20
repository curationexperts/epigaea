module Hyrax
  module Workflow
    # Notification of state change to "approved".
    # Should notify users with the approving role for the work's AdminSet, plus super users.
    class UnpublishedNotification < MiraWorkflowNotification
      def workflow_recipients
        { "to" => admins }
      end

      def subject
        "Deposit #{title} has been unpublished"
      end

      def message
        "#{title} (#{link_to work_id, document_url}) has been unpublished by #{user.display_name} (#{user.user_key}).  #{comment}"
      end
    end
  end
end
