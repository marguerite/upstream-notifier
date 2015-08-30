class Github

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'date'
	require_relative '../utils.rb'
	include Utils

	MONTN_NO_UPDATE = 6

	def initialize(url='',version='')

		if url.index("github.com")
			@url = url
		else
			@url = "https://github.com/" + url
		end

		@version = version

	end

	def check()

                release = lastRelease()
                commit = lastCommit()
                rd = releaseDate()
                now = Time.now.strftime("%Y%m").to_i

                if ( @version == "nil" || @version.empty? )
                        if release
                                return release
                        else
                                return commit
                        end
                elsif @version.index("+")

                        return commit

                else

                        if ( now - rd ) > MONTH_NO_UPDATE

                                return commit

                        else

                                return release

                        end

                end
	
	end

	def lastRelease()

		release = Nokogiri::HTML(open(@url + '/releases')).xpath('//ul[@class="release-timeline-tags"]/li[1]/div/div/h3/a/span').text

		return release

	end

	def releaseDate()

		dstring = Nokogiri::HTML(open(@url + '/releases')).xpath('//ul[@class="release-timeline-tags"]/li[1]/span/time/@datetime').first.value.gsub(/T.*$/,'')

		darray = dstring.split('-')

		date = darray[0] + darray[1]

		return date

	end

	def lastCommit()

		commit = Nokogiri::HTML(open(@url + '/commits/master')).xpath('//ol[contains(@class,"commit-group")]/li[1]/div[3]/div/a').first.text.strip!

		date = commitDate()

		if ( @version == "nil" || @version.empty? )

			prefix = "0.0.0"

		else

			prefix = @version.gsub(/\+.*$/,'')

		end

		version = prefix + "+git" + date + '.' + commit

		return version

	end

	def commitDate()

		dstring = Nokogiri::HTML(open(@url + '/commits/master')).xpath('//div[@class="commit-group-title"]').first.text.strip!

		x = dstring.gsub(/^.*on\s/,'').split(',')

		year = x[1].strip!

		y = x[0].split(/\s/)	

		month = returnMonth(y[0])

		day = y[1]

		date = year + month + day

		return date

	end

end

