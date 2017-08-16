module Tufts
  class HandleLogService
    include Singleton
    def self.log(who, what, message)
      instance.logger.info("#{what} | #{message} | #{who}")
    end

    def logger
      @logger ||= Logger.new(filename, 'monthly')
    end

    def filename
      Rails.root.join('log', 'handle.log')
    end
  end
end
