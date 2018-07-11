require 'net/smtp'

module UpstreamNotifier
  class Email
    def initialize(option, *args)
      @option = option['email']
      @updates, @user = args
    end

    def get
      message = <<MESSAGE_END
From: Upstream Notifier <
To:
Subject: [UpstreamNotifier] Your packages have new releases

DO NOT REPLY!

UpstreamNotifier just found new releases:

#{@updates.map {|k,v| k + ":" + v + "\n" }.join}

Please update ASAP!

Brief Changelog:

...

Generated by Upstream Notifier from marguerite <marguerite@opensuse.org>
If feel bothered or meet any trouble, please contact.
MESSAGE_END
      smtp = Net::SMTP.new @option['server'], @option['port']
      smtp.enable_starttls
      smtp.start('gmail.com', @option['from'], @option['password'], :login) do
        smtp.send_message(message, @option['from'], @user)
      end
    end
  end
end
