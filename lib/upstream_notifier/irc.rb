require 'socket'

module UpstreamNotifier
  class IRCBot
    def initialize(option)
      @option = option['irc']
      @socket = TCPSocket.open(@option['server'], @option['port'])
      login
    end

    def say(msg)
      @socket.puts("PRIVMSG ##{@option['channel']} :#{msg}\n")
    end

    private

    def login
      @socket.puts("NICK #{@option['user']}\n")
      @socket.puts("USER #{(@option['user'] + ' ') * 3} :#{@option['user']}\n")
      while line = @socket.gets.chomp!
        if line.split(' ')[1] == '376'
          @socket.puts("JOIN ##{@option['channel']}\n")
          break
        end
      end
    end

    def quit
      @socket.puts("PART ##{@option['channel']} :bye\n")
      @socket.puts("QUIT\n")
    end
  end
end
