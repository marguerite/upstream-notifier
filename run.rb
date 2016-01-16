#!/usr/bin/env ruby

require_relative 'config.rb'
require_relative 'options.rb'

mods = Array.new
changed = Hash.new

Dir.foreach('./mod') do |mod|
	mods << mod.gsub("\.rb",'') unless (mod == '.' || mod == '..')	
end

mods.each do |m|
	require_relative 'mod/' + m + '.rb'
end

config = Config.new(ARGV[0])

confs = config.parse

opts = Options.new('options.json').parse

notiMethod = opts["global"]["notification"]

threads = Array.new

confs.each_value do |pkg|

	thread = Thread.new {

		mods.each do |m|

			if pkg['mod'] == m

				version = Object.const_get(m.capitalize).new(pkg['url'],pkg['version']).check

				unless pkg['version'] == 'nil'

					if version > pkg['version']

						p "there's new release #{version} for #{pkg['name']}"

						changed[pkg['name']] = [pkg['version'],version]

					end

				else

					p "there's new release #{version} for #{pkg['name']}"

					changed[pkg['name']] = [pkg['version'],version]

				end

			end

		end

	}

	threads << thread

end

threads.each { |t| t.join }

config.write(changed) unless changed.empty?
