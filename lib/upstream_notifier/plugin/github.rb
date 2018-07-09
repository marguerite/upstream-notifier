require 'open-uri'
require 'nokogiri'
require 'date'

module UpstreamNotifier
  class Github
    def initialize(uri, old, *args)
      @old = old
      branch, @git = args
      branch ||= 'master'
      uri = 'https://github.com/' + uri.sub(%r{http(s)?://github\.com/}, '')
      @release_xml = Nokogiri::HTML(open(uri + '/releases', 'r:UTF-8'))
      @commit_xml = Nokogiri::HTML(open(uri + '/commits/' + branch, 'r:UTF-8'))
    end

    def get
      if release.nil?
        '0.0.0+git' + commit_date.strftime('%Y%m%d') + '.' + commit
      elsif @git.nil? && (Date.today - release_date).to_i > 180
        # if use_git, git version will be used when the release was made
        # more than 6 months ago.
        release + '+git' + commit_date.strftime('%Y%m%d') + '.' + commit
      else
        release
      end
    end

    def release
      page = @release_xml.xpath('//span[@class="tag-name"]')
      page.empty? ? nil : page.first.text
    end

    def release_date
      Date.parse(@release_xml.xpath('//span[@class="date"]/relative-time')
          .first.values[0])
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
