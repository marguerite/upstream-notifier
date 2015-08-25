#!/usr/bin/env ruby

class Fcitx

	require 'nokogiri'
	require 'open-uri'
	require 'date'
	require_relative 'github.rb'

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

		if ( @version == "nil" || @version.empty? )

			if lastRelease()

				return lastRelease()

			else

				return lastCommit()

			end

		elsif @version == lastRelease()

			return lastCommit()

		else

			month = Time.now.strftime("%Y%m")

			if ( month.to_i - releaseDate[4..5].to_i ) >= MONTH_NO_UPDATE

				return lastCommit

			else

				return lastRelease

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

		case darray[1]
		when "Jan"
                        month = "01"
                when "Feb"
                        month = "02"
                when "Mar"
                        month = "03"
                when "Apr"
                        month = "04"
                when "May"
                        month = "05"
                when "Jun"
                        month = "06"
                when "Jul"
                        month = "07"
                when "Aug"
                        month = "08"
                when "Sep"
                        month = "09"
                when "Oct"
                        month = "10"
                when "Nov"
			month = "11"
		when "Dec"
			month = "12"
		end

		date = year + month + day

		return date

	end

	def lastCommit()

		url = "https://github.com/fcitx/" + @url.gsub("http://",'').gsub(/^.*org/,'').gsub("/",'')

		version = Github.new(url,@version).lastCommit

		return version

	end

end

p Fcitx.new("fcitx-sunpinyin","0.4.0").check
