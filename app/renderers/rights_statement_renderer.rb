class RightsStatementRenderer < Hyrax::Renderers::AttributeRenderer
  private

    def attribute_value_to_html(value)
      begin
        parsed_uri = URI.parse(value)
      rescue
        nil
      end
      if parsed_uri.nil?
        ERB::Util.h(value)
      else
        %(<a href=#{ERB::Util.h(value)} target="_blank">#{Tufts::RightsStatementService.label(value)}</a>)
      end
    end
end
