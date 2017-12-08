module Tufts
  module HasTranscriptForm
    # return [Hash]
    def transcript_files
      transcript_files = file_presenters.select { |file| transcript?(file) }
      Hash[transcript_files.map { |file| [file.to_s, file.id] }]
    end

    # @param [Hyrax::FileSetPresenter] file
    def transcript?(file)
      file.to_s.end_with?('xml', 'tei') || file.mime_type.include?('xml')
    end

    # List of mime types used in MIRA
    MEDIA_MIME_TYPES = ['audio/wav', 'audio/x-wav', 'audio/wave', 'audio/mpeg',
                        'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3',
                        'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg',
                        'audio/x-mpegaudio', 'video/mp4', 'video/ogg', 'video/webm',
                        'video/avi', 'video/quicktime'].freeze

    # @param [Hyrax::FileSetPresenter] file
    #
    # return [Boolean]
    def media_file?(file)
      MEDIA_MIME_TYPES.include?(file.mime_type)
    end

    # return [Hash]
    def media_files
      transcript_files = file_presenters.select { |file| media_file?(file) }
      Hash[transcript_files.map { |file| [file.to_s, file.id] }]
    end
  end
end
