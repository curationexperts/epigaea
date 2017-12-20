module Hyrax
  module Workflow
    class MiraBatchNotification < MiraNotification
      def initialize(batch)
        @batch = batch
        @user = ensure_user(batch)
      end

      # Not all batch jobs have a user set. If the user is nil, assign the
      # batch user, for the purposes of the notification.
      def ensure_user(batch)
        return batch.user unless batch.user.nil?
        ::User.batch_user
      end

      def call
        return unless @batch.try(:ids).try(:count) > 0
        admins.uniq.each do |recipient|
          Hyrax::MessengerService.deliver(::User.batch_user, recipient, message, subject)
        end
      end

      def batch_name
        "Override this in your sub class"
      end

      def subject
        batch_name
      end

      def message
        "#{link_to batch_name, batch_url} was started by #{@user.display_name} (#{@user.user_key}) at #{@batch.created_at}."
      end

      ##
      # A fully qualified url to the batch
      def batch_url
        Rails.application.routes.url_helpers.send("batch_url", @batch.id)
      end
    end
  end
end
