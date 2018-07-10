require 'open-uri'
require 'nokogiri'

module UpstreamNotifier
  class Osdnjp
    def initialize(uri, *args)
      @xml = Nokogiri::HTML(open(uri).read)
    end

    def get
      @xml.xpath('//ul[contains(@class, "file-list")]/li/ul/li/a')
          .first.text.match(/\d+.*$/)[0]
    end
  end
end
