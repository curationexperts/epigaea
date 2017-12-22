module Hyrax
  module Workflow
    # A notification for a single item. Accepts an ActiveFedora::Base object
    # at initialization.
    class MiraNotification
      include ActionView::Helpers::UrlHelper

      attr_reader :depositor
      attr_reader :work
      attr_reader :title

      def initialize(work)
        @work = work
        @depositor = ::User.find_by_user_key(work.depositor)
        @title = @work.title.first
      end

      def recipients
        admins << @depositor
      end

      def call
        recipients.uniq.each do |recipient|
          Hyrax::MessengerService.deliver(::User.batch_user, recipient, message, subject)
        end
      end

      # The Users who have an admin role
      # @return [<Array>::User] an Array of Hyrax::User objects
      def admins
        Role.where(name: 'admin').first_or_create.users.to_a
      end

      ##
      # A fully qualified url to the work
      def work_url
        key = @work.model_name.singular_route_key
        Rails.application.routes.url_helpers.send(key + "_url", @work.id)
      end
    end
  end
end
