require 'nokogiri'
require 'open-uri'

module UpstreamNotifier
  class Cpan
    def initialize(uri, *_args)
      name = if uri =~ %r{http(s)://metacpan.org}
               uri.sub(/.*\//, '')
             elsif uri.index('::')
               uri.gsub('::', '-')
             else
               uri
             end
      @uri = 'https://metacpan.org/release/' + name
      @xml = Nokogiri::HTML(open(@uri, 'r:UTF-8'))
    end

    def get
      @xml.xpath('//span[@class="release-name"]').text.sub!(/.*-(\d+.*)/, '\1')
    end
  end
end
