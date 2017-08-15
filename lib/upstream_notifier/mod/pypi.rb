class Pypi
  require 'nokogiri'
  require 'open-uri'

  def initialize(url = '', _version = '')
    @url = if url.index('pypi.python.org')

             url

           else

             'https://pypi.python.org/pypi/' + url

           end
  end

  def check
    version = Nokogiri::HTML(open(@url)).xpath('//div[@id="breadcrumb"]/a[3]').text

    version
  end
end
