module Tufts
  module Normalizer
    def strip_whitespace(param_value)
      return nil if param_value.respond_to?(:empty?) && param_value.empty?

      normalizer.strip_whitespace(param_value)
    end

    def strip_whitespace_keep_newlines(param_value)
      return nil if param_value.respond_to?(:empty?) && param_value.empty?
      normalizer.strip_whitespace(param_value, keep_newlines: true)
    end

    def normalize_import_field(field, values)
      values = if field.name == :description || field.name == :abstract
                 strip_whitespace_keep_newlines(values)
               else
                 strip_whitespace(values)
               end
      values
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

    ##
    # @api private
    def normalizer
      @normalizer ||= WhitespaceNormalizer.new
    end
  end
end
