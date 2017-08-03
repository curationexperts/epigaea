module Tufts
  class ChangesetOverwriteStrategy
    ##
    # @!attribute changeset [rw]
    #   @return [ActiveFedora::Changeset]
    # @!attribute model [rw]
    #   @return [ActiveFedora::Base]
    attr_accessor :changeset, :model

    ##
    # @param changeset [ActiveFedora::ChangeSet]
    # @param model     [ActiveFedora::Base]
    def initialize(changeset: NullChangeSet.new, model:)
      @changeset = changeset
      @model     = model
    end

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
