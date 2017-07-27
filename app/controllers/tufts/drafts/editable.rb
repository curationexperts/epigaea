module Tufts
  module Drafts
    module Editable
      def edit
        if curation_concern.draft_saved?
          curation_concern.apply_draft
          @form = work_form_service.build(curation_concern, current_ability, self)
          render 'hyrax/base/edit'
        else
          super
        end
      end
    end
  end
end
