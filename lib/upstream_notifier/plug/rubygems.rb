class Rubygems

	require 'nokogiri'
	require 'open-uri'

	def initialize(url="",version="")

		if url.index("rubygems.org")

			@url = url

		else

			@url = "https://rubygems.org/gems/" + url

		end

	end

	def check()

		version = Nokogiri::HTML(open(@url)).xpath('//ol[contains(@class,"gem__versions")]/li[1]/a').text

		return version

	end

end

