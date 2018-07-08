module UpstreamNotifier
  class Irc
    def initialize(option, *args)
      @updates, @user, @bot = args
    end

    def get
      @updates.each do |k,v|
        @bot.say("#{@user}: #{k} has a new release #{v}")
      end
    end
  end
end
