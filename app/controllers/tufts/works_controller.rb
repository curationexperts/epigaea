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
      super
    end

    # Go through the params hash and normalize whitespace before handing it off to
    # object creation
    # @param [ActionController::Parameters] params
    def normalize_whitespace(params)
      byebug
      # For keep_newline_fields, keep single newlines, compress 2+ newlines to 2,
      # and otherwise strip whitespace as usual
      keep_newline_fields = ['description', 'abstract']
      params[hash_key_for_curation_concern].keys.each do |key|
        next unless params[hash_key_for_curation_concern][key].class == String
        params[hash_key_for_curation_concern][key] = if keep_newline_fields.include?(key)
                                        params[hash_key_for_curation_concern][key].gsub(/[ \t]+?[\n]{2,}[ \t]+?/, "\n\n").gsub(/[ \t]+/, " ").strip
                                      else
                                        params[hash_key_for_curation_concern][key].gsub(/\s+/, " ").strip
                                      end
      end
    end
  end
end
