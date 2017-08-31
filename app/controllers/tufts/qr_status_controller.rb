module Tufts
  class QrStatusController < ApplicationController
    protect_from_forgery with: :null_session

    def set_status
      model = ActiveFedora::Base.find(params[:id])
      model.mark_reviewed!
      render json: { batch_reviewed: true }
    end

    def status
      model = ActiveFedora::Base.find(params[:id])
      render json: { batch_reviewed: model.reviewed? }
    end
  end
end
