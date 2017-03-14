class Cpan

	require 'nokogiri'
	require 'open-uri'

	def initialize(url="",version="")

		if url.index("metacpan.org") then

			@url = url

		else

			@url = "https://metacpan.org/pod/" + url

		end

		@version = version

	end

	def check()

		version = Nokogiri::HTML(open(@url)).xpath('//h1[@id = "VERSION"]').first.next_element.text.split(/\s/)[1]

		return version

	end

end

