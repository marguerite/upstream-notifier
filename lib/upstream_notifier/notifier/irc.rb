module UpstreamNotifier
  class Irc
    def initialize(_option, *args)
      @updates, @user, @bot = args
    end

    def get
      @updates.each do |k, v|
        @bot.say("#{@user}: #{k} has new version #{v}\n")
      end
    end
  end
end
