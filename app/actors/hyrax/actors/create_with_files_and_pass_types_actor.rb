module Hyrax
  module Actors
    # Creates a work and attaches files to the work,
    # passes types through to the attach files job
    class CreateWithFilesAndPassTypesActor < CreateWithFilesActor
      def create(env)
        @thumbnail      = env.attributes.delete(:thumbnail)
        @transcript     = env.attributes.delete(:transcript)
        @representative = env.attributes.delete(:representative)
        super
      end

      ##
      # @return [TrueClass]nnn
      def attach_files(files, env)
        return true if files.blank?
        attributes = env.attributes.merge(file_type_attributes)
        AttachTypedFilesToWorkJob.perform_later(env.curation_concern, files, attributes.to_h.symbolize_keys)
        true
      end

      def file_type_attributes
        types = {}
        types[:thumbnail]      = @thumbnail      if @thumbnail.present?
        types[:transcript]     = @transcript     if @transcript.present?
        types[:representative] = @representative if @representative.present?
        types
      end
    end
  end
end
