module Hyrax
  class TemplatesController < ApplicationController
    def index
      @templates = Tufts::Template.all
    end

    def destroy
      name = params.delete(:id)

      Tufts::Template.for(name: name).delete

      @templates = Tufts::Template.all
      render action: :index
    end

    def edit
      object   = GenericObject.new
      template = Tufts::Template.for(name: params[:id])

      template.apply_to(model: object)

      @form = Hyrax::TemplateForm.new(object,
                                      current_ability,
                                      self,
                                      template: template)
    end

    def new
      object   = GenericObject.new
      template = Tufts::Template.new(name: 'New Template')

      @form = Hyrax::TemplateForm.new(object,
                                      current_ability,
                                      self,
                                      template: template)
      render :edit
    end

    def update
      old_template_name = params.require(:id)
      template_name     = params.require(:generic_object).require(:template_name)
      diff              = GenericObject.new(object_params)

      unless old_template_name == template_name
        old_template = Tufts::Template.new(name: old_template_name)
        old_template.delete if old_template.exists?
      end

      Tufts::Template.from_object(diff, name: template_name).save
      redirect_to main_app.templates_path, notice: "Saved #{template_name}"
    end

    def self.local_prefixes
      [controller_path, 'hyrax/base']
    end

    private

      def object_params
        Hyrax::TemplateForm.model_attributes(params.require(:generic_object))
      end
  end
end
