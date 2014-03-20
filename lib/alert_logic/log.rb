# Module accessor for logger instance
module AlertLogic
  @logger = nil

  # Set or return a logger instance
  def self.logger(logger_file = nil)
    if !@logger || logger_file
      if defined?(Chef::Log.logger) && !logger_file
        @logger = Chef::Log.logger
      else
        @logger = Logger.new(logger_file || $stdout)
        @logger.level = Logger::INFO
      end
    end
    @logger
  end

  # Set logger instance to another instance
  def self.logger=(logger)
    logger.is_a?(String) ? self.logger(logger) : @logger = logger
    @logger
  end
end
