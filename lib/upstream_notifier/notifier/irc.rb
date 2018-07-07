module UpstreamNotifier
  class Irc
    def initialize(option, *args)
      @name, @version, @bot = args
    end

    def get
      @bot.say("#{@name} has a new release #{@version}, maintainer please update!")
    end
  end
end
