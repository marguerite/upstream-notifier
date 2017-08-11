module UpstreamNotifier
  class Parser
    def initialize(config)
      @config = config # hash
    end

    def parse
      @config.each do |_k, v|
        # TODO: detect other args
        UpstreamNotifier::Plugin.send(v['plug'], v['url'], v['version'])
      end
    end
  end
end
