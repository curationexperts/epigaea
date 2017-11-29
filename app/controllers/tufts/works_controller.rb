module Tufts
  class WorksController < ApplicationController
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Tufts::Drafts::Editable
    include Tufts::Normalizer
    def create
      normalize_whitespace(params)
      super
    end

    def update
      normalize_whitespace(params)
      delete_draft(params)
      super
    end

    private

      def delete_draft(params)
        work = ActiveFedora::Base.find(params['id'])
        work.delete_draft
      end
  end
end
