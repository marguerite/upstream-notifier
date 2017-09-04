require 'nokogiri'
require 'open-uri'
require 'date'

module UpstreamNotifier
  class Fcitx
    def initialize(uri, old, *_args)
      @uri = if uri =~ %r{http(s)://download.fcitx-im.org}
               uri
             else
               'https://download.fcitx-im.org/' + uri
             end
      @old = old
      @xml = Nokogiri::HTML(open(@uri, 'r:UTF-8'))
    end

    def get
      rel, reldate = release
      com, comdate = commit
      if (Date.today - reldate) > 180
        rel + '+git' + comdate.strftime('%Y%m%d') + '.' + com
      else
        rel
      end
    end

    def release
      rel = @xml.xpath('//ul[@id="files"]/li[3]/a/span[@class="name"]').text.sub!(/.*-(\d+.*)\.tar.*/, '\1')
      reldate = Date.parse(@xml.xpath('//ul[@id="files"]/li[3]/a/span[@class="date"]').text)
      [rel, reldate]
    end

    def commit
      name = @uri.sub(%r{.*/(.*?)}, '\1')
      uri = 'https://github.com/fcitx/' + name
      path = File.expand_path(File.dirname(__FILE__))
      require path + '/github.rb'
      com = UpstreamNotifier::Github.new(uri, @old).commit
      com_date = UpstreamNotifier::Github.new(uri, @old).commit_date
      [com, com_date]
    end
  end
end
