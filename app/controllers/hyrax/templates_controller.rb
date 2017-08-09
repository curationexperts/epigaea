module Hyrax
  class TemplatesController < ApplicationController
    def index
      @templates = Tufts::Template.all
    end

    def destroy
      name = params.delete(:id)

      Tufts::Template.for(name: name).delete

      @templates = Tufts::Template.all
      redirect_to main_app.templates_path notice: "Deleted #{name}"
    end
  end
end
