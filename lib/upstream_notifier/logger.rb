module UpstreamNotifier
  # Log new version history to /home/pi/.upstreamnotifier
  class Logger
    def initialize(time, name, version)
      file = UpstreamNotifier::LOGPATH + '/upstream-notifier.log'
      Dir.mkdir(File.dirname(file)) unless File.exist?(File.dirname(file))
      open(file, 'a+:UTF-8').write("[#{time}] #{name}: #{version}\n")
    end
  end
end
