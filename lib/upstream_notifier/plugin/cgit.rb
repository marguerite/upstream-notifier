require 'nokogiri'
require 'open-uri'
require 'date'

module UpstreamNotifier
  class Cgit
    def initialize(uri, old, *_args)
      @uri = uri
      @old = old
    end

    def get
      rel, reldate = release
      com, comdate = commit
      if (Date.today - reldate).to_i > 180
        rel + '+git' + comdate.strftime('%Y%m%d') + '.' + com
      else
        rel
      end
    end

    private

    def release
      xml = Nokogiri::HTML(open(@uri + '/refs', 'r:UTF-8'))
      # the next tr of the 3rd tr with class "nohover" constains the latest release
      i = 0
      j = 0
      xml.xpath('//table[contains(@class, "list")]/tr').each do |tr|
        i += 1
        next if tr.attr('class').nil?
        j += 1
        break if j == 3
      end
      i += 1
      latest = xml.xpath("//table[contains(@class, 'list')]/tr[#{i}]")
      raw_release = latest.children[0].children[0].text
      release = raw_release.sub(/.*?(\d+.*\d+)/, '\1').tr('-', '.')
      datexml = Nokogiri::HTML(open(@uri + '/commit/?h=' + raw_release, 'r:UTF-8'))
      release_date = Date.parse(datexml.xpath('//td[@class="right"]')[0].text)
      [release, release_date]
    end

    def commit
      xml = Nokogiri::HTML(open(@uri + '/log'))
      latest = xml.xpath('//table[contains(@class, "list")]/tr[2]')
      commit_date = Date.parse(latest.children[0].text)
      commit = latest.children[1].children[0].attr('href').sub!(/.*id=(.*)/, '\1')[0..6]
      [commit, commit_date]
    end
  end
end
