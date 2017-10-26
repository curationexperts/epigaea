module Tufts
  module WorkflowStatus
    def self.status(id)
      work_id = id
      solr_doc_status = solr_status(work_id)
      if solr_doc_status == 'unpublished' || solr_doc_status == 'deposited'
        'unpublished'
      else
        # Only look for this status in Fedora if necessary
        work = ActiveFedora::Base.find(id)
        draft_status = work.draft_saved?
        if draft_status
          'edited'
        else
          'published'
        end
      end
    end

    def self.solr_status(id)
      document = SolrDocument.find(id)
      begin
        document['workflow_state_name_ssim'][0]
      rescue
        'unpublished'
      end
    end

    class << self
      private :solr_status
    end
  end
end
