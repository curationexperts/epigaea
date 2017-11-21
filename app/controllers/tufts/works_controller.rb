module Tufts
  class WorksController < ApplicationController
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Tufts::Drafts::Editable

    def create
      normalize_whitespace(params)
      super
    end

    def update
      normalize_whitespace(params)
      delete_draft(params)
      super
    end

    def strip_whitespace(param_value)
      return strip_whitespace_transformation(param_value) if param_value.class == String
      return param_value.map { |m| strip_whitespace_transformation(m) } if param_value.class == Array
      param_value
    end

    def strip_whitespace_keep_newlines(param_value)
      return strip_whitespace_keep_newlines_transformation(param_value) if param_value.class == String
      return param_value.map { |m| strip_whitespace_keep_newlines_transformation(m) } if param_value.class == Array
      param_value
    end

    def strip_whitespace_keep_newlines_transformation(string)
      string.gsub(/\r/, '').gsub(/[\n]{2,}/, "\n\n").gsub(/[ \t]+/, " ").strip
    end

    def strip_whitespace_transformation(string)
      string.gsub(/\s+/, " ").strip
    end

    # Go through the params hash and normalize whitespace before handing it off to
    # object creation
    # @param [ActionController::Parameters] params
    def normalize_whitespace(params)
      # For keep_newline_fields, keep single newlines, compress 2+ newlines to 2,
      # and otherwise strip whitespace as usual
      keep_newline_fields = ['description', 'abstract']
      params[hash_key_for_curation_concern].keys.each do |key|
        params[hash_key_for_curation_concern][key] = if keep_newline_fields.include?(key)
                                                       strip_whitespace_keep_newlines(params[hash_key_for_curation_concern][key])
                                                     else
                                                       strip_whitespace(params[hash_key_for_curation_concern][key])
                                                     end
      end
    end

    private

      def delete_draft(params)
        work = ActiveFedora::Base.find(params['id'])
        work.delete_draft
      end
  end
end
