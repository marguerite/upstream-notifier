require 'open-uri'
require 'nokogiri'
require 'date'

module UpstreamNotifier
  class Github
    def initialize(uri, *args)
      branch, @git = args
      branch ||= 'master'
      @git ||= false
      uri = 'https://github.com/' + uri.sub(%r{http(s)?://github\.com/}, '')
      @release_xml = Nokogiri::HTML(open(uri + '/releases', 'r:UTF-8').read)
      @commit_xml = Nokogiri::HTML(open(uri + '/commits/' + branch, 'r:UTF-8').read)
    end

    def get
      rel = release
      if @git && (Date.today - release_date).to_i > 180
        # if use_git, git version will be used when the release was made
        # more than 6 months ago.
        "#{rel}+git#{commit_date.strftime('%Y%m%d')}.#{commit}"
      else
        rel
      end
    end

    def release
      page = @release_xml.xpath('//span[@class="tag-name"]')
      page.empty? ? '0.0.0' : page.first.text
    end

    def release_date
      page = @release_xml.xpath('//span[@class="date"]/relative-time')
      page.empty? ? Date.today : Date.parse(page.first.values[0])
    end

    def commit
      @commit_xml.xpath('//div[contains(@class, "commit-links-group")]/a')
                 .first.text.strip!
    end

    def commit_date
      Date.parse(@commit_xml.xpath('//div[contains(@class, '\
                                   "'commit-author-section')]"\
                                   '/div/relative-time')
                            .first.values[0])
    end
  end
end
