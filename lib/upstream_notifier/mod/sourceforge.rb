#TODO: moodle and ngois check
class Sourceforge

	require 'rubygems'
	require 'nokogiri'
	require 'open-uri'
	require 'net/http'

	def initialize(url='',version='')

		# https://presage.sourceforge.net
		unless url.gsub(/^(https:\/\/|http:\/\/)/,'').index(/^sourceforge/)

			x = url.gsub(/^(https:\/\/|http:\/\/)/,'').split('.')

			# make sure url is http://sourceforge.net/projects/presage
			@url = 'http://' + x[1] + '.' + x[2] + '/projects/' + x[0]

		else

			@url = url

		end

		@name = @url.gsub(/^(https:\/\/|http:\/\/)/,'').split('/')[2]

		@version = version

	end

	def check

		if urlExists?(@url + '/files/' + @name)

			url = @url + '/files/' + @name

		else

			url = @url + '/files/' + @name.capatilize

		end

		release = Nokogiri::HTML(open(url)).css("div#page-body div#files table#files_list tbody tr:nth-child(1) th a").text.strip!		

		return release

	end

	def urlExists?(url=@url)

		uri = URI.parse(url)
		req = Net::HTTP.new(uri.host,uri.port)
		req.use_ssl = (uri.scheme == 'https')
		res = req.request_head('/')

		if res.code == "200"
			return true
		else
			return false
		end

	end

end

