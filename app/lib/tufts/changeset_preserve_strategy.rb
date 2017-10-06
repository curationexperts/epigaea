module Tufts
  ##
  # A changeset application strategy that preserves existing data.
  #
  # |type| source | template | result |
  # |---|---|---|---|
  # | single / multi | null | null | null |
  # | single / multi | value1 | null | value1 |
  # | single / multi | null | value2 | value2 |
  # | single  | value1 | value2 | **value1** |
  # | multi  | value1 | value2 | **value1+value2** |
  #
  class ChangesetPreserveStrategy < ChangesetApplicationStrategy
    ChangesetApplicationStrategy.register(:preserve, self)

    ##
    # @todo Refactor me!
    # @see ChangesetApplicationStrategy#apply
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
    # rubocop:disable Metrics/BlockNesting, Metrics/PerceivedComplexity
    # rubocop:disable Metrics/CyclomaticComplexity
    def apply
      changeset.changes.each do |predicate, graph|
        config = config_for(predicate: predicate)

        if config.nil?
          raise "Invalid ChangeSet. Property for #{predicate} does not " \
                "exist on #{model}"
        end

        property, config = config

        # Sorry about this terrible code. See the chart in the class docs for
        # a behavior spec.
        graph.group_by(&:subject).each do |subject, statements|
          if subject == model.rdf_subject
            values = statements.map(&:object).to_a

            if config.multiple?
              if config.term == :title
                model.public_send("#{property}=".to_sym, [values.first]) if
                  model.public_send(property).empty?
              else
                values += model.public_send(property).to_a
                model.public_send("#{property}=".to_sym, values)
              end
            else
              old_value = model.public_send(property)
              model.public_send("#{property}=".to_sym, values.first) unless
                old_value
            end
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
