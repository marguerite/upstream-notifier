class Cpan
  require 'nokogiri'
  require 'open-uri'

  def initialize(url = '', version = '')
    @url = if url.index('metacpan.org')

             url

           else

             'https://metacpan.org/pod/' + url

           end

    @version = version
  end

  def check
    version = Nokogiri::HTML(open(@url)).xpath('//h1[@id = "VERSION"]').first.next_element.text.split(/\s/)[1]

    version
  end
end
