class Rubygems
  require 'nokogiri'
  require 'open-uri'

  def initialize(url = '', _version = '')
    @url = if url.index('rubygems.org')

             url

           else

             'https://rubygems.org/gems/' + url

           end
  end

  def check
    version = Nokogiri::HTML(open(@url)).xpath('//ol[contains(@class,"gem__versions")]/li[1]/a').text

    version
  end
end
