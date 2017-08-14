module UpstreamNotifier
  class Parser
    def initialize(config, option)
      @config = config
      @option = option
    end

    def parse
      @config.each do |k, v|
        splat = v.reject { |m, _n| %w[plugin url version].include?(m) }
                 .values
        new = UpstreamNotifier::Plugin.send(v['plugin'], v['url'],
                                            v['version'], *splat)
        next unless @config[k]['version'] != new
        @config[k]['version'] == new
        notify(@option, k, new)
      end
      @config
    end

    private

    def notify(option, name, version)
      if option['notification'] == 'email'
p option['email']
        UpstreamNotifier::Mail.new(option['email'], name, version).send
      elsif option['notification'] == 'irc'
      end
    end
  end
end
