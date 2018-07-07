require 'thread'

module UpstreamNotifier
  class Parser
    def initialize(config, option)
      @config = config
      @option = option
      @packages = []
    end

    def parse
      parse_packages
      # init IRC bot
      bot, bot_started = bot_init
      # notify
      @packages.each { |i| i.notify(@option, bot) }
      # save work
      @config.config = @packages.map(&:to_h).inject(&:merge!)
      # shut the bot down
      bot.send(:quit) if bot_started
    end

    private

    def parse_packages
      # open 50 threads for each config file
      q = Queue.new
      @config.config.each { |k, v| q.push([k, v]) }
      workers = establish_workers(q, 4)
      workers.map(&:join)
    end

    def establish_workers(queue, max)
      (0...max).map do
        Thread.new do
          begin
            while x = queue.pop(true)
              @packages << UpstreamNotifier::Package.new(x[0], x[1],
                                                         @config.uri)
            end
          rescue ThreadError
          end
        end
      end
    end

    def bot_init
      return nil, false unless @packages.map(&:notifier).include?('irc')
      [UpstreamNotifier::IRCBot.new(@option), true]
    end
  end
end
