#!/usr/bin/env ruby

require_relative 'config.rb'

Dir.foreach('./mod') do |mod|
	require_relative 'mod/' + mod unless (mod == '.' || mod == '..')	
end

configObject = Config.new('config.json')

config = configObject.parse

changed = {}

config.each_value do |pkg|

	if pkg['catag'] == 'github'

		version = Github.new(pkg['url'],pkg['version']).check

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

configObject.write(changed) unless changed.empty?
