module UpstreamNotifier
  class Package
    RESERVED = %w(url version plugin notifier maintainer file).freeze

    def initialize(name, attr)
      @name = name
      @attr = attr
      @attr.each do |k, v|
        instance_variable_set("@#{k}", v)
        singleton_class.class_eval { attr_reader k.to_s }
      end
      @oldversion = nil
      update
    end

    attr_reader :name, :oldversion

    def to_h
      return {} unless @oldversion
      @attr['version'] = @version
      { @name => @attr }
    end

    private

    def update
      splat = [@url]
      splat += @attr.reject { |k, _v| RESERVED.include?(k) }.values
      new = UpstreamNotifier::Plugin.send(@plugin.to_sym, *splat)
      return @version if new.eql?(@version)
      @oldversion = @version
      @version = new
      UpstreamNotifier::Logger.new(Time.now, @name, @version)
    end
  end
end
