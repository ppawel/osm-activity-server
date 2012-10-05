require 'osm_activity_server/elogger'

module ActivityServerLogger
  class <<self
    attr_accessor :log
  end

  @@log = ::EnhancedLogger.new(STDOUT)
  @@log.level = Logger::DEBUG
  self.log = @@log
end

def log_time(name)
  before = Time.now
  if block_given?
    yield
  end
  end_time = Time.now
  ActivityServerLogger.log.debug("#{name} took #{Time.now - before}")
end
