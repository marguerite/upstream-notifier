require 'open-uri'
require 'nokogiri'

module UpstreamNotifier
  class Linuxapps
    def initialize(uri, *_args)
      @xml = Nokogiri::HTML(open(uri).read)
    end

    def get
      @xml.xpath('//div[contains(@class, "details")]/div/div/span')[1]
          .text.strip
    end
  end
end
