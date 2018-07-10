require 'json'
require 'open-uri'
require 'date'

module UpstreamNotifier
  class Googlecode
    def initialize(uri, *args)
      @name = uri.gsub(%r{http(s)?://code\.google\.com/(archive/)?p/}, '')
      @hg = args[0]
    end

    def get
      download = latest_download
      if @hg
        date = latest_commit_date
        return download if (Date.today - date).to_i <= 180
        download + '+hg' + date.strftime('%Y%m%d') + '.' + latest_commit
      else
        download
      end
    end

    private

    def download_json
      JSON.parse(open('https://www.googleapis.com/storage/v1/b/'\
                             'google-code-archive/o/v2%2Fcode.google.com'\
                             "%2F#{@name}%2Fdownloads-page-1.json?"\
                             'alt=media&stripTrailingSlashes=false').read)
    end

    def latest_download
      # t,z,r means tar, zip, rar
      download_json['downloads'].first['filename']
                                .match(/(\d+[^tzr]+)\./)[1]
    end

    def commits_json
      JSON.parse(open('https://www.googleapis.com/storage/v1/b/'\
                       'google-code-archive/o/v2%2Fcode.google.com'\
                       "%2F#{@name}%2Fcommits-page-1.json?"\
                       'alt=media&stripTrailingSlashes=false').read)
    end

    def latest_commit
      commits_json['commits'].first['commit']
    end

    def latest_commit_date
      Date.parse(commits_json['commits'].first['date'])
    end
  end
end
