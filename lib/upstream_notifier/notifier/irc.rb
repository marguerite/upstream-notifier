module UpstreamNotifier
  class Irc
    def initialize(option, *args)
      @name, @version, @maintainer, @bot = args
    end

    def get
      @bot.say("@#{@maintainer}: #{@name} has a new release #{@version}, maintainer please update!")
    end
  end
end
