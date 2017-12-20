module Hyrax
  module Workflow
    # Notification of state change to "approved".
    # Should notify users with the approving role for the work's AdminSet, plus super users.
    class CommentNotification < MiraWorkflowNotification
      def workflow_recipients
        { "to" => (admins << depositor) }
      end

      def subject
        "Comment about #{title}"
      end

      def message
        "#{user.display_name} (#{user.user_key}) has made a comment:
        <br/><br/>
        #{comment}
        <br/><br/>
        Regarding title: <br/><br/>
        #{title} (#{link_to work_id, document_url})
        "
      end
    end
  end
end
