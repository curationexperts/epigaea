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
  end
end
