module UpstreamNotifier
  class VCMP
    def initialize(old, new)
      @old = old
      @new = new
    end

    def compare
      old = [Regexp.match(1), Regexp.match(2)] if @old =~ /(.*)(+git.*)?/
      new = Regexp.match(1)
    end
  end
end
