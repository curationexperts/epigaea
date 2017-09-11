module Tufts
  class HandleLogController < ApplicationController
    load_and_authorize_resource
    def index
      respond_to do |format|
        format.html
        format.text { send_file Tufts::HandleLogService.instance.filename, type: 'text/plain' }
      end
    end
  end
end
