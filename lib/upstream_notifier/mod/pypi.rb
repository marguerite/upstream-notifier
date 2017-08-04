class Pypi

	require 'nokogiri'
	require 'open-uri'

	def initialize(url="",version="")

		if url.index("pypi.python.org")

			@url = url

		else

			@url = "https://pypi.python.org/pypi/" + url

		end

	end

	def check()

		version = Nokogiri::HTML(open(@url)).xpath('//div[@id="breadcrumb"]/a[3]').text

		return version

	end

end

