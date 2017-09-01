require 'nokogiri'
require 'open-uri'

module UpstreamNotifier
  class Sourceforge
    def initialize(uri, old, *_args)
      if uri =~ %r{http(s)?://(.*?)\.sourceforge\.net$} ||
         uri =~ %r{http(s)?://sourceforge.net/projects/([^/]+).*$}
        @name = Regexp.last_match(2)
      else
        raise "can not resolve #{uri}"
      end
      @uri = 'https://sourceforge.net/projects/' + @name + '/files'
      @old = old
    end

    def get
      recursive_get(@uri)
    end

    private

    def recursive_get(uri)
      xml = Nokogiri::HTML(open(uri, 'r:UTF-8'))
      trial = xml.xpath('//th[@headers="files_name_h"]/a').map { |i| i.text.strip! }.sort!
      if trial[0] =~ /\d+\.\d+/
        trial[-1]
      elsif trial.include?(@name)
        recursive_get(uri + '/' + @name)
      end
    end
  end
end
