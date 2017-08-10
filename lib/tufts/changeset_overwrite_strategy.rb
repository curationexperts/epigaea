module Tufts
  ##
  # A `ChangesetApplicationStrategy` that overwrites existing data in changed
  # fields.
  class ChangesetOverwriteStrategy < ChangesetApplicationStrategy
    ##
    # @return [void] applies the changeset to the model
    # @raise [RuntimeError] when the changeset is invalid for the model
    def apply # rubocop:disable Metrics/MethodLength
      changeset.changes.each do |predicate, graph|
        config = config_for(predicate: predicate)

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

    private

      def config_for(predicate:)
        model.class.properties.find { |_, v| v.predicate == predicate }
      end
  end
end
