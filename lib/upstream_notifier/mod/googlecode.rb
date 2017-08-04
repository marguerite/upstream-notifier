class Googlecode

	MONTH_NO_UPDATE = 6

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'date'
	require_relative '../utils.rb'
	include Utils

	def initialize(url="",version="")

		if url.index("code.google.com")
			@url = url
		else
			@url = "https://code.google.com/p/" + url
		end

		@version = version

	end

	def check()

		release = lastRelease()
		commit = lastCommit()
		rd = releaseDate().to_i
		now = Time.now.strftime("%Y%m").to_i

		# Logic: 
		# 0. if no version filled, then released version first
		# 1. if has a "+" (scm symbol), then last commit first
		# 2. if no new release for MONTH_NO_UPDATE months,
		#    prefer last commit, else use released version

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

		release = Nokogiri::HTML(open(@url + '/downloads/list')).xpath('//table[@id="resultstable"]/tr[1]/td[2]/a').text.strip!.gsub(/^.*-/,'').gsub(/\.tar.*$/,'')

		return release

	end

	def releaseDate()

		dstring = Nokogiri::HTML(open(@url + '/downloads/list')).xpath('//table[@id="resultstable"]/tr[1]/td[5]/a').text.strip!

		darray = dstring.split(/\s/)

		year = darray[1]

		month = returnMonth(darray[0])

		date = year + month

		return date

	end

	def lastCommit()

		commit = Nokogiri::HTML(open(@url + '/source/list')).xpath('//table[@id="resultstable"]/tr[2]/td[1]/a').text # r147

		scm = Nokogiri::HTML(open(@url + '/source/checkout')).xpath('//div[@class="bubble_wrapper"]/div/div[@class="box-inner"]/tt[@id="checkoutcmd"]').text.split(/\s/)[0]

		date = commitDate()

		if ( @version == "nil" || @version.empty? )
			prefix = "0.0.0+"
		elsif 
			prefix = @version.gsub(/\+.*$/,'')
		end 

		version = prefix + scm + date + '.' + commit

		return version

	end

	def commitDate()

		dstring = Nokogiri::HTML(open(@url + '/source/list')).xpath('//table[@id="resultstable"]/tr[2]/td[3]/a').text

		darray = dstring.split(/\s/)

		year = darray[2]

		month = returnMonth(darray[0])

		day = darray[1].gsub(',','')

		date = year + month + day

		return date

	end

end

