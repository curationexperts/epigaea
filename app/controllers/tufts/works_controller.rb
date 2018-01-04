module Tufts
  class WorksController < ApplicationController
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Tufts::Drafts::Editable
    include Tufts::Normalizer

    before_action :redirect_non_admins

    def create
      normalize_whitespace(params)
      super
      Hyrax::Workflow::SelfDepositNotification.new(curation_concern).call
    end

    def update
      normalize_whitespace(params)
      delete_draft(params)
      super
    end

    private

      def redirect_non_admins
        redirect_to root_url unless current_user && current_user.admin?
      end

      def delete_draft(params)
        work = ActiveFedora::Base.find(params['id'])
        work.delete_draft
      end
  end
end
