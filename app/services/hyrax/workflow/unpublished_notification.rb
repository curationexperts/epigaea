module Hyrax
  module Workflow
    # Notification of state change to "approved".
    # Should notify users with the approving role for the work's AdminSet, plus super users.
    class UnpublishedNotification < MiraNotification
      def workflow_recipients
        { "to" => admins }
      end

      private

        def subject
          "Deposit #{title} has been unpublished"
        end

        def message
          "#{title} (#{link_to work_id, document_path}) has been unpublished by #{user.display_name}.  #{comment}"
        end
    end
  end
end
