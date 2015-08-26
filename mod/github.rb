#!/usr/bin/env ruby

class Github

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'date'

	def initialize(url='',version='')

		@url = url

		@version = version

	end

	def check()

		if @version == "nil"

			lastCommit()

		elsif ! @version.index('git')

			lastRelease()

		else

			lastCommit()

		end	

	end

	def lastRelease()

		release = Nokogiri::HTML(open(@url + '/releases')).css('div.wrapper div.site div.container div.repository-content div.release-timeline ul.release-timeline-tags li:nth-child(1) div.main div.tag-info span.tag-name').text

		return release

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
