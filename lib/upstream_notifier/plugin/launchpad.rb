require 'nokogiri'
require 'open-uri'
require 'date'

module UpstreamNotifier
  class Launchpad
    def initialize(uri, old, *_args)
      @uri = uri
      @old = old
      @xml = Nokogiri::HTML(open(@uri, 'r:UTF-8'))
    end

    def get
      rel, reldate = release
      com, comdate, flavor = commit
      if (Date.today - reldate).to_i > 180
        rel + '+' + flavor + comdate.strftime('%Y%m%d') + '.' + com
      else
        rel
      end
    end

    def release
      rel = @xml.xpath('//div[@id="downloads"]/div[@class="version"]').text.sub!(/.*\s(\d+.*)/, '\1').strip!
      reldate = @xml.xpath('//div[@id="downloads"]/div[@class="released"]').text.sub!(/.*\s(\d+.*)/, '\1').strip!
      reldate = Date.parse(reldate)
      [rel, reldate]
    end

    def commit
      uri = @xml.xpath('//a[contains(@class, "menu-link-source")]').attr('href').value
      if uri.end_with?('files')
        xml = Nokogiri::HTML(open(uri, 'r:UTF-8'))
        commit = xml.xpath('//div[@id="breadcrumbs"]/span').text.sub!(/^.*\s(\d+.*?)\)$/m, '\1')
        commitdate = xml.xpath('//div[@id="infTxt"]/ul/li[@class="timer"]/span').text
        commitdate = Date.parse(commitdate)
        [commit, commitdate, 'bzr']
      else
        require './cgit.rb'
        res = UpstreamNotifier::Cgit.new(uri, @old).commit
        res << 'git'
      end
    end
  end
end
