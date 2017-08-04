require 'nokogiri'
require 'open-uri'
require 'date'

module UpstreamNotifier
    class Github
	def initialize(uri, old, branch="master")
	    @old = old
	    uri = 'https://github.com/' + uri.sub(/http(s)?:\/\/github\.com\//, '')
	    @release_xml = if UpstreamNotifier::Ping.new(uri + '/releases', 5000).ping?
				Nokogiri::HTML(open(uri + '/releases', 'r:UTF-8'))
			   else
				nil
			   end
	    @commit_xml = Nokogiri::HTML(open(uri + '/commits/' + branch, 'r:UTF-8'))
	end

	def get(use_git=true)
	    new = if @release_xml.nil?
			"0.0.0+git" + commit_date.strftime('%Y%m%d') + "." + commit
		  elsif use_git && (Date.today - release_date).to_i > 180
		  # if use_git, git version will be used when the release was made more than 6 months ago.
			release + "+git" + commit_date.strftime('%Y%m%d') + "." +  commit
		  else
			release
		  end
	    UpstreamNotifier::VCMP.new(@old, new).compare ? new : @old
	end

	def release
	    @release_xml.xpath('//span[@class="tag-name"]').first.text
	end

	def release_date
	    Date.parse(@release_xml.xpath('//span[@class="date"]/relative-time').first.values[0])
	end

	def commit
	    @commit_xml.xpath('//div[contains(@class, "commit-links-group")]/a').first.text.strip!
	end

	def commit_date
	    Date.parse(@commit_xml.xpath('//div[contains(@class, "commit-author-section")]/relative-time').first.values[0])
	end
    end
end

require_relative '../common/ping.rb'
p UpstreamNotifier::Github.new('https://github.com/fcitx/fcitx', '4.2.9').get
