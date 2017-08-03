require 'sparql'

module Tufts
  ##
  # A SPARQL serializer/deserializer for ActiveFedora::ChangeSet
  #
  # @see https://www.w3.org/TR/sparql11-update/
  class ChangesetSerializer
    ##
    # @param changeset [ActiveFedora::ChangeSet]
    #
    # @return [String] a SPARQL string
    def serialize(changeset:, subject:)
      return '' if changeset.empty?
      ActiveFedora::SparqlInsert.new(changeset.changes, subject).build
    end

    ##
    # We can't just apply the sparql string, because <> (null relative uri's)
    # used by ActiveFedora is unsupported in SPARQL, so we need to parse and
    # reconstruct the insert set manually.
    #
    # @param str   [String]
    # @param model [ActiveFedora::Base]
    # @return [ActiveFedora::ChangeSet]
    def deserialize(str, model:)
      statements = extract_insert_statements(str, model.rdf_subject)

      changeset =
        ActiveFedora::ChangeSet.new(model,
                                    changed_graph(statements, model),
                                    changed_attribute_keys(statements, model))
      # cache the changes
      changeset.changes
      changeset
    end

    private

      def config_for_predicate(predicate, model)
        model.class.properties.find { |_, v| v.predicate == predicate }
      end

      ##
      # @return [Array<Symbol>]
      def changed_attribute_keys(statements, model)
        statements.map(&:predicate).uniq.map do |predicate|
          config_for_predicate(predicate, model)
        end.compact.map(&:first)
      end

      ##
      # @return [RDF::Graph]
      def changed_graph(statements, model)
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
      # @return [Array<RDF::Statement>)
      def extract_insert_statements(update_string, subject)
        return [] if update_string.nil? || update_string.empty?

        inserts = SPARQL.parse(update_string, update: true).each_descendant.select do |op|
          op.is_a? SPARQL::Algebra::Operator::Insert
        end

        inserts.flat_map do |insert|
          insert.operand.map do |pattern|
            RDF::Statement(subject, pattern.predicate, pattern.object)
          end
        end
      end
  end
end
