require 'open-uri'
require 'nokogiri'
require 'date'

module UpstreamNotifier
  class Gitlab
    def initialize(uri, *args)
      @uri = "https://gitlab.com/" + uri
      branch, @git = args
      branch ||= "master"
      @git ||= false
      @release_xml = Nokogiri::HTML(open(@uri + "/tags").read)
      @commit_xml = Nokogiri::HTML(open(@uri + "/commits/#{branch}").read)
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
      page = @release_xml.xpath('//ul[contains(@class, "content-list")]/li/'\
                                'div[contains(@class, "row-main-content")]/a')
      page.empty? ? '0.0.0' : page.first.text
    end

    def latest_release_date
      date = @release_xml.xpath('//div[@class="branch-commit"]/time')
      date.empty? ? Date.today : Date.parse(date.first['datetime'])
    end

    def latest_commit_date
      Date.parse(@commit_xml.xpath('//span[@class="day"]').first.text)
    end

    def latest_commit
      @commit_xml.xpath('//div[@class="commit-sha-group"]/div')
                 .first.text.strip!
    end
  end
end
