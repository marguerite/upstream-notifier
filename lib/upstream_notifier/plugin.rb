module UpstreamNotifier
  # dynamically require and call plugins in plug directory
  class Plugin
    class << self
      def method_missing(plug, *args)
        super unless plugin?(plug)
        uri, old, *plug_args = args
        require File.expand_path(File.dirname(__FILE__)) + "/plug/#{plug}.rb"
        "UpstreamNotifier::#{plug.to_s.capitalize}".split('::')
                                                   .inject(Object) do |o, c|
                                                     o.const_get(c)
                                                   end
                                                   .new(uri, old, plug_args).get
      end

      def respond_to_missing?(plug)
        plugin?(plug) || super
      end
    end

    def self.plugin?(plug)
      plugins = Dir.glob(File.expand_path(File.dirname(__FILE__)) + '/plug/*')
      return false if plugins.empty?
      plugins = plugins.map! do |i|
        File.basename(i)
            .match(/(.*)\.rb$/)[1]
            .to_sym
      end
      plugins.include?(plug) ? true : false
    end
  end
end
