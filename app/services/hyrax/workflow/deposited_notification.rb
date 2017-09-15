module Hyrax
  module Workflow
    class DepositedNotification < AbstractNotification
      private

        def subject
          "New self-deposit: #{title}"
        end

        def message
          "#{title} (#{link_to work_id, document_path}) was deposited by #{user.user_key}."
        end

        def users_to_notify
          user_key = ActiveFedora::Base.find(work_id).depositor
          super << ::User.find_by(email: user_key)
        end
    end
  end
end
