class Fcitx

	require 'nokogiri'
	require 'open-uri'
	require 'date'
	require_relative 'github.rb'
	require_relative '../utils.rb'
	include Utils

	MONTH_NO_UPDATE = 6

	def initialize(url="",version="")

		# You can just specify by the name

		unless url.index("download.fcitx-im.org") then

			@url = "http://download.fcitx-im.org/" + url

		else

			@url = url

		end

		@version = version

	end

	def check()

		release = lastRelease()
		commit = lastCommit()
		rd = releaseDate().to_i
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

			if ( now - rd ) >= MONTH_NO_UPDATE

				return commit

			else

				return release

			end	

		end

	end

	def lastRelease()

		tarball = Nokogiri::HTML(open(@url)).css('div#wrapper ul#files li:last-child a span.name').text

		# fcitx-sunpinyin-0.4.1.tar.xz
		version = tarball.gsub(/^.*-/,'').gsub(/\.tar.*$/,'')

		return version

	end

	def releaseDate()

		dstring = Nokogiri::HTML(open(@url)).css('div#wrapper ul#files li:last-child a span.date').text # Sun Feb 02 2014 20:41:15

		darray = dstring.split(/\s/)

		day = darray[2]

		year = darray[3]

		month = returnMonth(darray[1])

		date = year + month + day

		return date

	end

	def lastCommit()

		url = "https://github.com/fcitx/" + @url.gsub("http://",'').gsub(/^.*org/,'').gsub("/",'')

		version = Github.new(url,@version).lastCommit

		return version

	end

end

