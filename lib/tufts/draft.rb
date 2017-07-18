require 'active_fedora'
require 'sparql'

module Tufts
  ##
  # A set of draft metadata edits
  class Draft
    ##
    # @!attribute [rw] changeset
    #   @return [ActiveFedora::Changeset]
    # @!attribute [rw] id
    #   @return [String]
    # @!attribute [rw] model
    #   @return [Tufts::Draftable]
    attr_accessor :changeset, :id, :model

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
      self.changeset = changeset
      self.id        = id
      self.model     = model
    end

    ##
    # @return [void] applies the changeset to the model
    def apply # rubocop:disable Metrics/MethodLength
      changeset.changes.each do |predicate, graph|
        config = config_for_predicate(predicate)

        if config.nil?
          raise "Invalid ChangeSet. Property for #{predicate} does not " \
                "exist on #{model}"
        end

        property, config = config

        graph.group_by(&:subject).each do |subject, statements|
          if subject == model.rdf_subject
            values = statements.map(&:object)
            values = values.first unless config.multiple?
            model.send("#{property}=".to_sym, values)
          else
            model.resource.insert(*statements)
          end
        end
      end
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
      return @changeset = NullChangeSet.new unless exists?

      File.open(path) { |f| from_sparql(f.read) }
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
      File.open(path, 'w+') { |f| f.write(to_sparql) }
      self
    end

    private

      ##
      # We can't just apply the sparql string, because <> (null relative uri's)
      # used by ActiveFedora is unsupported in SPARQL, so we need to parse and
      # reconstruct the insert set manually.
      #
      # @return [void]
      def from_sparql(update_string)
        statements = extract_insert_statements(update_string)

        self.changeset =
          ActiveFedora::ChangeSet.new(model,
                                      changed_graph(statements),
                                      changed_attribute_keys(statements))
        # cache the changes
        changeset.changes
      end

      ##
      # @return [RDF::Graph]
      def changed_graph(statements)
        graph = model.resource.dup

        grouped = statements.group_by do |statement|
          statement.subject.to_base + statement.predicate.to_base
        end

        grouped.each do |_, sts|
          graph.update(sts.pop)
          graph.insert(*sts)
        end

        graph
      end

      ##
      # @return [Array<Symbol>]
      def changed_attribute_keys(statements)
        statements.map(&:predicate).uniq.map do |predicate|
          config_for_predicate(predicate)
        end.compact.map(&:first)
      end

      def config_for_predicate(predicate)
        model.class.properties.find { |_, v| v.predicate == predicate }
      end

      ##
      # @return [Array<RDF::Statement>)
      def extract_insert_statements(update_string)
        return [] if update_string.nil? || update_string.empty?

        inserts = SPARQL.parse(update_string, update: true).each_descendant.select do |op|
          op.is_a? SPARQL::Algebra::Operator::Insert
        end

        inserts.flat_map do |insert|
          insert.operand.map do |pattern|
            RDF::Statement(pattern.subject, pattern.predicate, pattern.object)
          end
        end
      end

      ##
      # @return [String] a SPARQL Update string
      def to_sparql
        return '' if changeset.empty?
        ActiveFedora::SparqlInsert.new(changeset.changes, model.rdf_subject).build
      end

      def path
        STORAGE_DIR.join(id)
      end
  end
end
