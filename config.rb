class Config

	require 'json'
	require 'fileutils'
	require 'date'

	NAME = "upstream-notifier"

	def initialize(config="")

		defaultPath = File.join(Dir.home(ENV['LOGNAME']),"/.config/",NAME)

		Dir.mkdir(defaultPath) unless Dir.exists?(defaultPath)

		@config = config || defaultPath + "/config.json"		

	end

	def parse()

		input = ""

		open(@config,'r') do |conf|

			input = conf.read

		end

		json = JSON.parse(input)

		return json

	end

	def write(changed={})

		open(@config,'r') do |f0|

			open(@config + ".new",'w') do |f1|

				i = 0

				f0.each do |l|

					changed.each do |k,v|

						if l.index(k) && l.index('name') then

							i = 1

							f1 << l

							open(@config,'r') do |f|

								f.each do |l1|

									if l1.index(v[0])									
										f1 << l1.gsub(v[0],v[1])

										break

									end

								end

							end

						end

					end

					f1 << l if i == 0

					if (i == 1 && l.index("version"))

						i = 0

					end

				end

			end

		end

		date = Time.now.strftime("%Y%m%d")

		FileUtils.mv(@config,@config + '.old.' + date)
		FileUtils.mv(@config + '.new',@config)

	end

end

