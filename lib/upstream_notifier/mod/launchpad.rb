class Launchpad

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'date'

	def initialize(url="",version="")

		if url.index("launchpad.net")

			@url = url

		else

			@url = "https://launchpad.net/" + url

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

		release = Nokogiri::HTML(open(@url)).xpath('//div[@id="side-portlets"]/div[@id="downloads"]/div[@class="version"]').text.strip!.split(/\s/)[3]

		return release

	end

	def releaseDate()

		dstring = Nokogiri::HTML(open(@url)).xpath('//div[@id="side-portlets"]/div[@id="downloads"]/div[@class="released"]').text.strip!.split(/\s/)[2]

		darray = dstring.split('-')

		date = darray[0] + darray[1] + darray[2]

		return date

	end

	def lastCommit()

		bzr_repo = Nokogiri::HTML(open(@url)).xpath('//dl[@id="dev-focus"]/dd/p[2]/a[2]/@href').first.value

		bzr_commit = Nokogiri::HTML(open(bzr_repo)).xpath('//div[@id="breadcrumbs"]/span').text.split(/\s/)[5].gsub(')','')

		dstring = Nokogiri::HTML(open(bzr_repo)).xpath('//div[@id="infTxt"]/ul/li[@class="timer"]/span').text.split(/\s/)[0]

		darray = dstring.split('-')

		commit_date = darray[0] + darray[1] + darray[2]

		if @version == "nil" || @version.empty?

			prefix = "0.0.0"

		else

			# 1.0+bzr, 1.0.0
			prefix = @version.gsub(/\+.*$/,'')

		end

		version = prefix + "+bzr" + commit_date + "." + bzr_commit

		return version

	end

end

