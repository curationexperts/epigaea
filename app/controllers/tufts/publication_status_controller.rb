module Tufts
  class PublicationStatusController < ApplicationController
    protect_from_forgery with: :null_session

    before_action :authenticate_user!

    def publish
      work = ActiveFedora::Base.find(params[:id])
      subject = Hyrax::WorkflowActionInfo.new(work, current_user)
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("publish", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "Published by #{current_user}")
      render json: { published: true }
    end

    def unpublish
      work = ActiveFedora::Base.find(params[:id])
      subject = Hyrax::WorkflowActionInfo.new(work, current_user)
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("unpublish", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: "Unpublished by #{current_user}")
      render json: { unpublished: true }
    end

    def status
      work = ActiveFedora::Base.find(params[:id])
      render json: { status: work.to_sipity_entity.reload.workflow_state_name }
    end
  end
end
