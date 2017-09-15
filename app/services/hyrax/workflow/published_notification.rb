module Hyrax
  module Workflow
    # Notification of state change to "approved".
    # Should notify users with the approving role for the work's AdminSet, plus super users.
    class PublishedNotification < MiraNotification
      def workflow_recipients
        { "to" => (admins << depositor) }
      end

      private

        def subject
          "Deposit #{title} has been published"
        end

        def message
          "#{title} (#{link_to work_id, document_path}) has been published by #{user.display_name}  #{comment}"
        end
    end
  end
end
