require 'nokogiri'
require 'open-uri'

module UpstreamNotifier
  class Rubygem
    def initialize(uri, old, *_args)
      @uri = if uri =~ /http/
               uri
             else
               'https://rubygems.org/gems/' + uri
             end
      @old = old
      @xml = Nokogiri::HTML(open(@uri, 'r:UTF-8'))
    end

    def get
      @xml.xpath('//div[@class="versions"]/ol/li[1]/a').text
    end
  end
end
