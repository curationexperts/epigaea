module Hyrax
  module Workflow
    # Notify admin users that a template has been applied to a batch
    class TemplateNotification
      def initialize(template_name:, count:, batch:, user:)
        @template_name = template_name
        @count = count
        @batch = batch
        @user = user
      end

      def call
        admins.uniq.each do |recipient|
          Hyrax::MessengerService.deliver(::User.batch_user, recipient, message, subject)
        end
      end

      # The Users who have an admin role
      # @return [<Array>::User] an Array of Hyrax::User objects
      def admins
        Role.where(name: 'admin').first_or_create.users.to_a
      end

      def subject
        "Template #{@template_name}"
      end

      def message
        "Template '#{@template_name}' has been applied to #{@count} objects in batch #{@batch.id} by #{@user.display_name} (#{@user.email})."
      end
    end
  end
end
