require 'yaml'

module UpstreamNotifier
  # handle yaml config
  class Config
    def initialize(uri)
      @uri = uri
      @config = YAML.safe_load(open(@uri, 'r:UTF-8').read)
    end

    attr_reader :uri, :config

    def config=(hash)
      open(@uri, 'w:UTF-8').write(hash.to_yaml)
      @config = hash
    end
  end
end
