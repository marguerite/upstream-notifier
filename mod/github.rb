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

		release = Nokogiri::HTML(open(@url + '/releases')).css('div.wrapper div.site div.container div.repository-content div.release-timeline ul.release-timeline-tags li:nth-child(1) div.main div.tag-info span.tag-name').text

		return release

	end

	def releaseDate()

		dstring = Nokogiri::HTML(open(@url + '/releases')).xpath('//ul[@class="release-timeline-tags"]/li[1]/span/time/@datetime').first.value.gsub(/T.*$/,'')

		darray = dstring.split('-')

		date = darray[0] + darray[1]

		return date

	end

	def lastCommit()

		commit = Nokogiri::HTML(open(@url + '/commits/master')).css('div.wrapper div.site div.container div.repo-container div.repository-content div.commits-listing ol.commit-group').first.css('li:nth-child(1) div.commit-links-cell div.commit-links-group a.sha').text.strip!

		date = commitDate()

		if ( @version == "nil" || @version.empty? )

			prefix = "0.0.0+git#{date}."

		else

			prefix = @version.gsub(/\+.*$/,'') + '+git' + date + '.'

		end

		version = prefix + commit

		return version

	end

	def commitDate()

		dstring = Nokogiri::HTML(open(@url + '/commits/master')).css('div.wrapper div.site div.container div.repo-container div.repository-content div.commits-listing div.commit-group-title').first.text.strip!

		x = dstring.gsub(/^.*on\s/,'').split(',')

		year = x[1].strip!

		y = x[0].split(/\s/)	

		month = returnMonth(y[0])

		day = y[1]

		date = year + month + day

		return date

	end

end

