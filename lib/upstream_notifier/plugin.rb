module UpstreamNotifier
  # dynamically require and call plugins in plugin directory
  class Plugin
    class << self
      def method_missing(plug, *args)
        super unless UpstreamNotifier::PLUGS.include?(plug)
        require Dir.glob(File.dirname(__FILE__) + '/*/' + plug.to_s + '.rb')[0]
        "UpstreamNotifier::#{plug.to_s.capitalize}".split('::')
                                                   .inject(Object) do |o, c|
                                                     o.const_get(c)
                                                   end
                                                   .new(*args).get
      end

      def respond_to_missing?(plug)
        UpstreamNotifier::PLUGS.include?(plug) || super
      end
    end
  end
end
