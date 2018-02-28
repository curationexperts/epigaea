# frozen_string_literal: true

##
# Extends `Tufts::Curation::Indexer` to index batches.
class MiraIndexer < Tufts::Curation::Indexer
  def generate_solr_document
    super.tap do |solr_doc|
      # Batches store ids as a serialized array. To retrieve them, we query
      # "ids LIKE...". To avoid potential substring collisions (this shouldn't
      # happen in normal operation), we follow up by filtering the results with
      # `#select`, before mapping to batch ids.
      batches = Batch.where("ids LIKE '%#{object.id}%'")
                     .select { |batch| batch.ids.include?(object.id) }
                     .map(&:id)

      unless batches.empty?
        batch_key = Solrizer.solr_name('batch', :stored_searchable)
        solr_doc[batch_key] = batches
      end
    end
  end
end
