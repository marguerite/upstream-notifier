require 'curb'

module UpstreamNotifier
  # ping network connectivity
  class Ping
    def initialize(uri, timeout)
      @uri = uri
      @timeout = timeout
    end

    def ping?
      r = Curl::Easy.new(@uri)
      r.timeout_ms = @timeout
      r.perform
      r.response_code == '404' ? false : true
    rescue
      false
    end
  end
end
