class Options

	require 'json'

	NAME = "upstream-notifier"

	def initialize(options="")

		defaultPath = File.join(Dir.home(ENV['LOGNAME']),"/.config/",NAME)

		Dir.mkdir(defaultPath) unless Dir.exists?(defaultPath)

		@options = options || defaultPath + "/options.json"		

	end

	def parse()

		input = ""

		open(@options,'r') do |opts|

			input = opts.read

		end

		json = JSON.parse(input)

		return json

	end

end

