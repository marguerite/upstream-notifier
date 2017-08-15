module UpstreamNotifier
  # dynamically require and call plugins in plugin directory
  class Plugin
    class << self
      def method_missing(plug, dirname, *args)
        super unless include?(plug, dirname)
        require File.expand_path(File.dirname(__FILE__) + '/' + dirname + '/' + plug.to_s + '.rb')
        "UpstreamNotifier::#{plug.to_s.capitalize}".split('::')
                                                   .inject(Object) do |o, c|
                                                     o.const_get(c)
                                                   end
                                                   .new(*args).get
      end

      def respond_to_missing?(plug)
        %w[plugin notifier].map! { |i| include?(plug, i) }.include?(true) || super
      end
    end

    def self.include?(plug, dirname)
      plugins = Dir.glob(File.expand_path(File.dirname(__FILE__) + '/' + dirname + '/*'))
      return false if plugins.empty?
      plugins = plugins.map! do |i|
        File.basename(i)
            .match(/(.*)\..*$/)[1]
            .to_sym
      end
      plugins.include?(plug)
    end
  end
end
