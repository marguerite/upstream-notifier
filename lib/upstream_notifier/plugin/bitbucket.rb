require 'open-uri'
require 'nokogiri'
require 'date'

module UpstreamNotifier
  class Bitbucket
    def initialize(uri, *args)
      @uri = "https://bitbucket.org/" + uri
      branch, @git = args
      branch ||= "master"
      @git ||= false
p @uri + "/downloads"
      @release_xml = Nokogiri::HTML(open(@uri + "/downloads/").read)
p @uri + "/commits/branch/master"
      @commit_xml = Nokogiri::HTML(open(@uri + "/commits/branch/#{branch}").read)
    end

    def get
      rel = latest_release
      if @git && (Date.today - latest_release_date).to_i > 180
        "#{rel}+git#{latest_commit_date.strftime('%Y%m%d')}.#{latest_commit}"
      else
        rel
      end
    end

    private

    def latest_release
      page = @release_xml.xpath('//tr[@class="iterable-item"]/td[@class="name"]/'\
                                'a')
      page.empty? ? '0.0.0' : page.first.text.match(/(\d+[^tzr]+)\./)[1]
    end

    def latest_release_date
      date = @release_xml.xpath('//tr[@class="iterable-item"]/td[@class="date"]/'\
                                'div/time')
      date.empty? ? Date.today : Date.parse(date.first['datetime'])
    end

    def latest_commit_date
      Date.parse(@commit_xml.xpath('//tr[@class="iterable-item"]/'\
                                   'td[@class="date"]/div/time').first['datetime'])
    end

    def latest_commit
      @commit_xml.xpath('//tr[@class="iterable-item"]/td[@class="hash"]/div/a')
                 .first.text
    end
  end
end
