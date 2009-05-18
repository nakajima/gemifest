module Gemifest
  class Gem
    def initialize(line)
      @line = line.gsub(/((?:<|>)?=)\s/, '\1')
      @parts = @line.split(/\s+/)
      @opts = {}
    end

    def install!
      `gem install #{@line} --no-ri --no-rdoc`
    end

    def parse!
      OptionParser.new do |opts|
        opts.on("-s", "--source SOURCE")   { |s| @opts[:source] = s }
        opts.on("-v", "--version VERSION") { |v| @opts[:version] = v }
      end.parse!(@parts) ; @opts[:name] = @parts.pop ; self
    end

    def version
      get :version
    end

    def source
      get :source
    end

    def name
      get :name
    end

    alias_method :to_s, :name

    private

    def get(name)
      if val = @opts[name]
        val.to_s.gsub(/"|'/, '')
      end
    end
  end
end
