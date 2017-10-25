module Hyrax
  class Template < ::GenericObject
  end

  class TemplateForm < Hyrax::Forms::WorkForm
    self.model_class = ::GenericObject

    self.terms += Tufts::Terms.shared_terms
    Tufts::Terms.remove_terms.each { |term| terms.delete(term) }
    self.terms.unshift(:template_name)

    self.required_fields = []

    ##
    # @see Hyrax::Forms::WorkForm.permitted_params
    def self.permitted_params
      super - [:template_name]
    end

    ##
    # @!attribute template [rw]
    #   @return [Tufts::Template]
    attr_accessor :template

    ##
    # @!method name
    #   @return (see Tufts::Template#name)
    delegate :name, to: :template, prefix: :template

    ##
    # @see Hyrax::Forms::WorkForm#initialize
    def initialize(model,
                   ability,
                   controller,
                   template: Tufts::Template.new(name: 'New Template'))
      @template = template
      super(model, ability, controller)
    end

    def action
      "/templates/#{template_name}"
    end
  end
end
