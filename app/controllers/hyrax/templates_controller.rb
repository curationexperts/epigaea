module Hyrax
  class TemplatesController < ApplicationController
    def index
      @templates = Tufts::Template.all
    end
  end
end
