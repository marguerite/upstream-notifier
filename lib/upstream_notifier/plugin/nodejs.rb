require 'nokogiri'
require 'open-uri'

module UpstreamNotifier
  class Nodejs
    def initialize(uri, *args)
      @uri = uri
    end

    def get
       xml = Nokogiri::HTML(open(@uri).read)
       xml.xpath('//section/p[@class="color-lightgray"]/strong').first.text
    end
  end
end
