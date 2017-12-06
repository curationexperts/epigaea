module Tufts
  class PublicationStatusController < ApplicationController
    protect_from_forgery with: :null_session

    before_action :authenticate_user!

    def publish
      work = ActiveFedora::Base.find(params[:id])
      work.delete_draft
      Tufts::WorkflowStatus.publish(work: work, current_user: current_user, comment: "Published by #{current_user}")
      flash[:notice] = "ID #{params[:id]} has been published."
      redirect_back(fallback_location: root_path)
    end

    def unpublish
      work = ActiveFedora::Base.find(params[:id])
      Tufts::WorkflowStatus.unpublish(work: work, current_user: current_user, comment: "Unpublished by #{current_user}")
      flash[:notice] = "ID #{params[:id]} has been unpublished."
      redirect_back(fallback_location: root_path)
    end

    def status
      work = ActiveFedora::Base.find(params[:id])
      render json: { status: work.to_sipity_entity.reload.workflow_state_name }
    end
  end
end
