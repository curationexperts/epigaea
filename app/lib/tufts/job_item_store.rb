module Tufts
  class JobItemStore
    def self.key_for(object_id:, batch_id:)
      "#{object_id}_#{batch_id}_job"
    end

    def self.add(object_id:, job_id:, batch_id:)
      store
        .write(key_for(object_id: object_id, batch_id: batch_id),
               job_id,
               expiration)
    end

    def self.fetch(object_id:, batch_id:)
      store.fetch(key_for(object_id: object_id, batch_id: batch_id))
    end

    def self.store
      ActiveJobStatus.store
    end

    def self.expiration
      ActiveJobStatus.expiration
    end
  end
end
