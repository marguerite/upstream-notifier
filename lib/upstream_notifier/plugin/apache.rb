require 'open-uri'
require 'nokogiri'

module UpstreamNotifier
  class Apache
    def initialize(url, _version, *_args)
      @xml = Nokogiri::HTML(open(url).read)
    end

    def get
      table = parse('//tr/td')
      return table if table
      parse('//ul/li')
    end

    def parse(pattern)
      @xml.xpath(pattern + '/a').map(&:children).map(&:first).map(&:text)
          .map { |i| i =~ /(\d+[^tzr]+)\./ ? Regexp.last_match[1] : nil }
          .compact.sort[-1]
    end
  end
end
