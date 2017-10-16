require 'active_fedora'
require 'sparql'

module Tufts
  ##
  # A set of draft metadata edits
  class Draft
    ##
    # @!attribute [rw] apply_strategy
    #   @return [Tufts::ChangesetOverwriteStrategy]
    # @!attribute [rw] changeset
    #   @return [ActiveFedora::ChangeSet]
    # @!attribute [rw] id
    #   @return [String]
    # @!attribute [rw] model
    #   @return [Tufts::Draftable]
    # @!attribute [rw] serializer
    #   @return [Tufts::ChangesetSerializer]
    attr_accessor :apply_strategy, :changeset, :id, :model, :serializer

    ##
    # @!method apply
    #   @return [void] applies the changeset to the model
    #   @see Tufts::ChangesetOverwriteStrategy#apply
    delegate :apply, to: :apply_strategy

    STORAGE_DIR = Pathname.new(Rails.configuration.drafts_storage_dir).freeze

    ##
    # @param model [ActiveFedora::Base]
    # @return [Draft] A draft including the unsaved changes from the model
    def self.from_model(model)
      draft = new(model: model)
      draft.id = model.id if model.id

      draft.changeset =
        ActiveFedora::ChangeSet.new(model,
                                    model.resource,
                                    model.changed_attributes.keys)
      # Force cache of changeset#changes. We don't want the draft's change
      # list to change if the in-memory model is edited
      draft.changeset.changes
      draft
    end

    ##
    # @param changeset [ActiveFedora::ChangeSet]
    # @param id        [String]
    # @param model     [ActiveFedora::Base]
    def initialize(model:, changeset: NullChangeSet.new, id: SecureRandom.uuid)
      self.changeset      = changeset
      self.id             = id
      self.model          = model
      self.serializer     = ChangesetSerializer.new
      self.apply_strategy = Tufts::ChangesetOverwriteStrategy
                            .new(model: model, changeset: changeset)
    end

    ##
    # Drafts are equal if they operate on the same model object and
    # contain the same changes.
    #
    # @see Object#==
    def ==(other)
      other.model.eql?(model) &&
        (other.changeset.changed_attributes.to_set ==
         changeset.changed_attributes.to_set) &&
        (changeset.changes == other.changeset.changes)
    end

    ##
    # Deletes the draft and empties the changeset.
    #
    # @example
    #   draft = Draft.new(model: a_draftable)
    #   draft.exists # => false
    #
    #   draft.save
    #   draft.exists # => true
    #
    #   draft.delete
    #   draft.exists           # => false
    #   draft.changeset.empty? # => true
    #
    # @return [Draft] self
    def delete
      File.delete(path) if exists?
      load
    end

    ##
    # @return [Boolean]
    def exists?
      File.exist? path
    end

    ##
    # Loads the changeset from the saved version.
    # @return [Draft] self
    def load
      if exists?
        File.open(path) do |f|
          self.changeset = serializer.deserialize(f.read, model: model)
        end
      else
        @changeset = NullChangeSet.new
      end

      self
    end

    ##
    # Saves the draft.
    #
    # @example
    #   draft = Draft.new(model: a_draftable)
    #   draft.exists # => false
    #
    #   draft.save
    #   draft.exists # => true
    #
    # @return [Draft] self
    def save
      File.open(path, 'w+') do |f|
        f.write(serializer.serialize(changeset: changeset, subject: model.rdf_subject))
      end

      self
    end

    private

      def path
        STORAGE_DIR.join(id)
      end
  end
end
