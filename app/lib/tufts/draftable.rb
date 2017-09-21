module Tufts
  ##
  # A  Mixin for making `ActiveFedora::Base`-like objects able to manage draft
  # versions.
  #
  # @example saving a draft
  #   class MyModel < ActiveFedora::Base
  #     include Draftable
  #     property :title,   predicate: RDF::Vocab::DC.title
  #     property :subject, predicate: RDF::Vocab::DC.subject
  #   end
  #
  #   object = MyModel.create(title: ['temporary title'])
  #   object.title   = ['Draft Title']
  #   object.subject = ['Draft Subject']
  #   object.save_draft
  #
  #   object.reload      # empty the unsaved changes
  #   object.apply_draft # recover the changes from the draft
  #
  module Draftable
    ##
    # @return [void]
    def delete_draft
      draft.delete
    end

    ##
    # Gives a draft object based on this model. If a draft exists for the model
    # (`#draft_saved?`), that draft is loaded; otherwise a new draft is created
    # reflecting the current state of this object.
    #
    # @return [Draft] a draft version of this object
    def draft
      draft = Draft.from_model(self)
      draft.load if draft.exists?
      draft
    end

    ##
    # @note A saved draft may be empty.
    # @return [Boolean] true if a draft hs been saved for this object
    def draft_saved?
      draft.exists?
    end

    ##
    # @see Draft#apply
    def apply_draft
      draft.apply
    end

    ##
    # @see Draft#save
    def save_draft
      draft.save
    end
  end
end
