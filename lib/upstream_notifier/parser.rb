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
      @users = parse_users
      # init IRC bot
      bot, bot_started = bot_init
      # notify
      @users.each { |i| i.notify(@option, bot) }
      # save work
      # @config.config = @packages.map(&:to_h).inject(&:merge!)
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

    def parse_users
      users = []
      @packages.each do |i|
        contacts = i.maintainer.split(',')
        email = contacts.select { |j| j.index('@') }[0]
        nick = contacts.reject { |j| j.index('@') }[0]
        if email.nil?
          unless users.map(&:nick).include?(nick)
            users << UpstreamNotifier::User.new(nil, nick)
          end
          users.select { |j| j.nick.eql?(nick) }[0].add_package(i)
        else
          unless users.map(&:email).include?(email)
            users << UpstreamNotifier::User.new(email, nil)
          end
          users.select { |j| j.email.eql?(email) }[0].add_package(i)
        end
      end
      users
    end

    def establish_workers(queue, max)
      (0...max).map do
        Thread.new do
          begin
            while x = queue.pop(true)
              @packages << UpstreamNotifier::Package.new(x[0], x[1])
            end
          rescue ThreadError
          end
        end
      end
    end

    def bot_init
      notifiers = @packages.map(&:notifier).uniq
      return nil, false unless notifiers.include?('irc') || notifiers.include?('all')
      [UpstreamNotifier::IRCBot.new(@option), true]
    end
  end
end
