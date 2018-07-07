module UpstreamNotifier
  class Package
    RESERVED = [%w(url version plugin notifier maintainer)].freeze

    def initialize(name, attr, path)
      @name = name
      @path = path
      @attr = attr
      @attr.each do |k, v|
        instance_variable_set("@#{k}", v)
        singleton_class.class_eval { attr_reader k.to_s }
      end
      update
    end

    def to_h
      return {} unless @oldversion
      @attr['version'] = @version
      { @name => @attr }
    end

    def notify(option, bot)
      return unless @oldversion
      UpstreamNotifier::Plugin.send(@notifier.to_sym, option,
                                    @name, @version,
                                    @maintainer, bot)
    end

    private

    def update
      splat = [@url, @version]
      splat += @attr.reject { |k, _v| RESERVED.include?(k) }.values
      new = UpstreamNotifier::Plugin.send(@plugin.to_sym, *splat)
      return @version if new.eql?(@version)
      @oldversion = @version
      @version = new
      UpstreamNotifier::Logger.new(Time.now, @name, @version)
    end
  end
end
