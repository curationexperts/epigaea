module Tufts
  class QrStatusController < ApplicationController
    protect_from_forgery with: :null_session

    def set_status
      model = ActiveFedora::Base.find(params[:id])
      model.qr_status = ['Batch Reviewed']
      model.save
      render json: { batch_reviewed: true }
    end

    def status
      model = ActiveFedora::Base.find(params[:id])
      status = if model.qr_status == ['Batch Reviewed']
                 true
               else
                 false
               end
      render json: { batch_reviewed: status }
    end
  end
end
