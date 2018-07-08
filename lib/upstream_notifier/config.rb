require 'yaml'

module UpstreamNotifier
  # handle yaml config
  class Config
    def initialize(uri)
      @uri = uri
      # modify the returned hash to append file containing it
      yaml = YAML.safe_load(open(@uri, 'r:UTF-8').read)
      @config = yaml.each_with_object(yaml) { |(k, _v), h| h[k]['file'] = @uri; }
    end

    attr_accessor :config

    def persistent(_file = @uri, origin = true)
      config = deep_copy(@config)
      new = config.each_with_object(config) do |(k, _v), h|
        h[k] = h[k].reject! { |m, _n| m.eql?('file') }
      end
      if origin
        sorted = sort(@config, new)
        sorted.each do |k, v|
          open(k, 'w:UTF-8').write(v.to_yaml)
        end
      else
        open(@uri, 'w:UTF-8').write(new.to_yaml)
      end
    end

    def delete!(key)
      @config.reject! { |k, _v| k.eql?(key) }
    end

    def set(k, v)
      @config[k] = v
    end

    def merge(other)
      # deep copy with Marshal
      me = deep_copy(self)
      other.config.each do |k, v|
        next if me.config.key?(k) && me.config[k] == v
        me.set(k, v)
      end
      me
    end

    def merge!(other)
      other.config.each do |k, v|
        if @config.key?(k) && @config[k] == v
          other.delete!(k)
        else
          @config[k] = v
        end
      end
      self
    end

    private

    def deep_copy(obj)
      Marshal.load(Marshal.dump(obj))
    end

    def sort(addressed, unaddressed)
      sorted = {}
      addressed.each do |k, v|
        if sorted.keys.include?(v['file'])
          sorted[v['file']][k] = unaddressed[k]
        else
          sorted[v['file']] = { k => unaddressed[k] }
        end
      end
      sorted
    end
  end
end
