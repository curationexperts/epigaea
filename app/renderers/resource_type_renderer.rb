class ResourceTypeRenderer < Hyrax::Renderers::AttributeRenderer
  SERVICE = Tufts::ResourceTypeService

  ##
  # @private
  def attribute_value_to_html(value)
    SERVICE.label(value)
  rescue SERVICE::LookupError
    value
  end
end
