module Tufts
  module WorkflowStatus
    def self.status(id)
      work_id = id
      solr_doc_status = solr_status(work_id)
      if solr_doc_status == 'unpublished' || solr_doc_status == 'deposited'
        'unpublished'
      else
        # Only look for this status in Fedora if necessary
        published_or_edited(id)
      end
    end

    def self.solr_status(id)
      document = SolrDocument.find(id)
      states = document.fetch('workflow_state_name_ssim') { ['unpublished'] }
      states.first
    end

    def self.draft_exist?(id)
      Rails.application.config.drafts_storage_dir.join(id).exist?
    end

    ##
    # publish a work, and kick off a handle registration job if appropriate
    def self.publish(work:, current_user:, comment:)
      subject = Hyrax::WorkflowActionInfo.new(work, current_user)
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("publish", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: comment)
      Hyrax::Actors::HandleAssuranceActor.ensure_handle(object: work)
    end

    ##
    # unpublish a work
    def self.unpublish(work:, current_user:, comment:)
      subject = Hyrax::WorkflowActionInfo.new(work, current_user)
      sipity_workflow_action = PowerConverter.convert_to_sipity_action("unpublish", scope: subject.entity.workflow) { nil }
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: comment)
    end

    def self.published_or_edited(id)
      if draft_exist?(id)
        'edited'
      else
        'published'
      end
    end

    class << self
      private :solr_status
      private :draft_exist?
      private :published_or_edited
    end
  end
end
