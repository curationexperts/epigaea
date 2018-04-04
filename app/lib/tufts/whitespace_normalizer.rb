module Tufts
  ##
  # Normalize whitespace for string input
  class WhitespaceNormalizer
    ##
    # @param [Enumerable<#to_str>, #to_str] value
    #
    # @return [String, nil]
    def strip_whitespace(value, keep_newlines: false)
      if value.respond_to?(:to_str)
        strip_string(value.to_str, keep_newlines: keep_newlines)
      elsif value.is_a?(Enumerable)
        value
          .map { |v| v.respond_to?(:to_str) ? strip_string(v.to_str, keep_newlines: keep_newlines) : v }
          .compact
      else
        value
      end
    end

    def strip_string(string, keep_newlines: false)
      stripped =
        if keep_newlines
          string.delete("\r")
                .gsub(/[\n]{2,}/, "\n\n")
                .gsub(/[ \t]+/, " ")
                .gsub(/[ \t]$/, '')
                .strip
        else
          string.gsub(/\s+/, " ").strip
        end

      stripped.empty? ? nil : stripped
    end
  end
end
