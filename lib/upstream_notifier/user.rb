module UpstreamNotifier
  class User
    def initialize(email, nick)
      @email = email
      @nick = nick
      @id = email.nil? ? nick : email
      @packages = []
    end

    attr_reader :email, :nick

    def add_package(package)
      @packages << package
    end

    def notify(option, bot)
      return if updated.empty?
      packages = sort_by_notifier
      peers = sort_name_version_peer(packages)
      peers.each do |k, v|
        UpstreamNotifier::Plugin.send(k.to_sym, option,
				      v, @id, bot)
      end
    end

    private

    def updated
      @packages.reject {|i| i.oldversion.nil? }
    end

    def sort_by_notifier
      notifiers = {}
      @packages.each do |i|
	if notifiers.keys.include?(i.notifier)
	  notifiers[i.notifier] << i
	else
	  notifiers[i.notifier] = [i]
	end
      end
      notifiers
    end

    def sort_name_version_peer(packages)
      packages.inject(packages) do |h, (k,v)|
	hash = {}
	v.each {|i| hash[i.name] = i.version }
        h[k] = hash
	h
      end
    end
  end
end
