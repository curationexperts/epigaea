module Tufts
  class HandleLogController < ApplicationController
    def index
      respond_to do |format|
        format.html
        format.text { send_file Tufts::HandleLogService.instance.filename, type: 'text/plain' }
      end
    end
  end
end
