require 'nokogiri'
require 'open-uri'

module UpstreamNotifier
  class Pypi
    def initialize(uri, old, *_args)
      @uri = if uri =~ %r{http(s)://pypi.org/project}
               uri
             else
               'https://pypi.org/project/' + uri
             end
      @old = old
      @xml = Nokogiri::HTML(open(@uri, 'r:UTF-8'))
    end

    def get
      @xml.xpath('//div[contains(@class, "release__card")]')[0].children[1].text
    end
  end
end
