class Cgit

	# You can not skip the '.git' in the cgit URL

	require 'nokogiri'
	require 'open-uri'

	MONTH_NO_UPDATE = 6

	def initialize(url="",version="")

		@url = url

		@version = version

	end

	def check()

		if @version == "nil"

			unless lastRelease().empty?

				return lastRelease()[0]

			else
				
				return lastCommit()

			end

		else

			if ( lastRelease().empty? || lastRelease[0] == @version )	

				# If upstream has no new release last MONTH_NO_UPDATE months,
				# git version will be used

				tstring = lastRelease()[1]

				# "8 months" "3 years"
				tarray = tstring.split(/\s/)

				if tarray[1] == "years"

					return lastCommit()

				elsif ( tarray[1] == "months" && tarray[0] > MONTH_NO_UPDATE )

					return lastCommit()

				else

					return lastRelease[0]

				end

			else

				return lastCommit()

			end

		end

	end

	def lastRelease()

		version = Nokogiri::HTML(open(@url)).xpath('//table[contains(@class,"list")]/tr[5]/td[2]/a').text

		date = Nokogiri::HTML(open(@url)).xpath('//table[contains(@class,"list")]/tr[5]/td[4]').text

		return version,date

	end

	def lastCommit()


		dstring = Nokogiri::HTML(open(@url + "/log")).xpath('//table[contains(@class,"list")]/tr[2]/td[1]').text

		darray = dstring.split("-")

		date = darray[0] + darray[1] + darray[2]

		commit = Nokogiri::HTML(open(@url + "/log")).xpath('//table[contains(@class,"list")]/tr[2]/td[2]/a/@href').first.value

		shortcommit = commit.gsub(/^.*?id=/,'')[0..6]

		if ( @version == "nil" || @version.empty? ) then

			prefix = "0.0.0"

		else

			prefix = @version.gsub(/\+git.*$/,'')

		end

		version = prefix + '+git' + date + '.' + shortcommit

		return version

	end

end

