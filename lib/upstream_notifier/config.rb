require 'yaml'

module UpstreamNotifier
    class Config
	def initialize(config)
	    @config = YAML.safe_load(open(File.expand_path(File.dirname(__FILE__)) + '/config/' + config + '.yml', 'r:UTF-8').read)
	end

	def parse
	    @config
	end

	def self.parse(config)
	    UpstreamNotifier::Config.new(config).parse
	end
    end
end
