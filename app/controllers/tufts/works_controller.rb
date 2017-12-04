module Tufts
  class WorksController < ApplicationController
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Tufts::Drafts::Editable
    include Tufts::Normalizer
    def create
      normalize_whitespace(params)
      rights_statement_scalar_fix(params)
      super
    end

    def update
      normalize_whitespace(params)
      rights_statement_scalar_fix(params)
      delete_draft(params)
      super
    end

    private

      def delete_draft(params)
        work = ActiveFedora::Base.find(params['id'])
        work.delete_draft
      end

      def rights_statement_scalar_fix(params)
        index = if Rails.env.production?
                  2
                else
                  3
                end
        return if params[params.keys[index]]['rights_statement'].nil?
        params[params.keys[index]]['rights_statement'] = [params[params.keys[index]]['rights_statement']]
      end
  end
end
