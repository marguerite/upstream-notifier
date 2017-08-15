module UpstreamNotifier
  # Log new version history to /home/pi/.upstreamnotifier
  class Logger
    def initialize(time, name, version)
      @time = time
      @name = name
      @version = version
      @uri = "/home/#{ENV['LOGNAME']}/.upstream-notifier/upstream-notifier.log"
    end

    def write
      Dir.mkdir(File.dirname(@uri)) unless File.exist?(File.dirname(@uri))
      open(@uri, 'a+:UTF-8').write("[#{@time}] #{@name}: #{@version}\n")
    end

    def self.write(time, name, version)
      UpstreamNotifier::Logger.new(time, name, version).write
    end
  end
end
