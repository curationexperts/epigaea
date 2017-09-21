module Tufts
  module HasTranscriptForm
    def transcript_files
      transcript_files = file_presenters.select { |file| transcript?(file) }
      Hash[transcript_files.map { |file| [file.to_s, file.id] }]
    end

    def transcript?(file)
      file.mime_type.include?('xml')
    end
  end
end
