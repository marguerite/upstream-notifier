require 'nokogiri'
require 'open-uri'

module UpstreamNotifier
  class Golang
    def initialize(uri, *args)
      @uri = uri
    end

    def get
       xml = Nokogiri::HTML(open(@uri).read)
       xml.xpath('//div[@class="container"]/a/div/span[@class="filename"]')
          .last.text.match(/(\d+[^tzr]+)\./)[1]
    end
  end
end
