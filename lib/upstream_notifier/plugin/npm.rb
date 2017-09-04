require 'nokogiri'
require 'open-uri'

module UpstreamNotifier
  class Npm
    def initialize(uri, old, *_args)
      @uri = if uri =~ %r{http(s)://www.npmjs.com}
               uri
             else
               'https://www.npmjs.com/package/' + uri
             end
      @old = old
      @xml = Nokogiri::HTML(open(@uri, 'r:UTF-8'))
    end

    def get
      @xml.xpath('//div[@class="sidebar"]/ul/li/strong')[0].text
    end
  end
end
