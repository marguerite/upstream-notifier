module UpstreamNotifier
  class Parser
    def initialize(config, option)
      @config = config
      @option = option
    end

    def parse
      @config.each do |k, v|
        splat = [v['url'], v['version']]
        splat += v.reject { |m, _n| %w[plugin url version].include?(m) }
                  .values
        new = UpstreamNotifier::Plugin.send(v['plugin'], 'plugin', *splat)
        next unless @config[k]['version'] != new
        @config[k]['version'] = new
        UpstreamNotifier::Logger.write(Time.now, k, new)
        UpstreamNotifier::Plugin.send(@option['notification'], 'notifier', @option, k, new) 
      end
      @config
    end
  end
end
