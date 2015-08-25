#!/usr/bin/env ruby

require_relative 'config.rb'
require_relative 'options.rb'

mods = []
changed = {}

Dir.foreach('./mod') do |mod|
	mods << mod.gsub("\.rb",'') unless (mod == '.' || mod == '..')	
end

mods.each do |m|
	require_relative 'mod/' + m + '.rb'
end

configObj = Config.new('config.json')

config = configObj.parse

optObj = Options.new('options.json')

opts = optObj.parse

notiMethod = opts["global"]["notification"]

config.each_value do |pkg|

	p "processing #{pkg['name']}"

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

end

configObj.write(changed) unless changed.empty?
