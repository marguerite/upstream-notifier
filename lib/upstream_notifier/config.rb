require 'yaml'

module UpstreamNotifier
  # handle yaml config
  class Config
    def initialize(config, path="config")
      @config_uri = File.expand_path(File.dirname(__FILE__) +
                                     "/#{path}/#{config}.yml")
      @config = YAML.safe_load(open(@config_uri, 'r:UTF-8').read)
    end

    def parse
      @config
    end

    def write(config)
      open(@config_uri, 'w:UTF-8').write(config.to_yaml)
    end
  end
end
