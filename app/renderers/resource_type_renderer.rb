class ResourceTypeRenderer < Hyrax::Renderers::AttributeRenderer
  private

    def attribute_value_to_html(value)
      Tufts::ResourceTypeService.label(value)
    end
end
