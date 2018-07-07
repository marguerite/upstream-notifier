module UpstreamNotifier
  def self.confident_path(type)
    if File.exist?("/home/#{ENV['LOGNAME']}/.upstream-notifier/#{type}")
      "/home/#{ENV['LOGNAME']}/.upstream-notifier/#{type}"
    else
      File.expand_path(File.dirname(__FILE__) + "/../../#{type}")
    end
  end

  VERSION = '1.0.0'.freeze
  PLUGS = Dir.glob(File.expand_path(File.dirname(__FILE__)) + '/*/*.rb')
             .map { |i| File.basename(i, '.rb').to_sym }
  CONFIGPATH = UpstreamNotifier.confident_path('config')
  OPTIONPATH = UpstreamNotifier.confident_path('option')
  OPTIONS = UpstreamNotifier::Config.new(UpstreamNotifier::OPTIONPATH + '/option.yml').config
  LOGPATH = UpstreamNotifier.confident_path('log')
end
