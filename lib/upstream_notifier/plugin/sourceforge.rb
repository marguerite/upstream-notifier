require 'nokogiri'
require 'open-uri'

module UpstreamNotifier
  class Sourceforge
    def initialize(uri, *args)
      @name = args[0]
      if uri =~ %r{([^/]+)\.sourceforge\.net$} ||
         uri =~ %r{/sourceforge\.net/projects/([^/]+)}
        uri_name = Regexp.last_match(1)
      else
        raise "unrecognized uri: #{uri}"
      end
      @name ||= uri_name
      @uri = "https://sourceforge.net/projects/#{uri_name}/files"
    end

    def get
      return unless @uri
      recursive_get(@uri)
    end

    private

    def recursive_get(uri)
      xml = Nokogiri::HTML(open(uri, 'r:UTF-8'))
      trial = xml.xpath('//th[@headers="files_name_h"]/a')
                 .map(&:text).map(&:strip).sort!
      if trial[0] =~ /^\d+/
        trial.select { |i| i =~ /^\d+/ }[-1]
      elsif trial.include?(@name)
        recursive_get(uri + '/' + @name)
      end
    end
  end
end
