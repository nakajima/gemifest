module Gemifest
  def self.all(reload=false)
    @all = nil if reload
    @all ||= `#{@gem_command} list`.split(/\n/)
  end

  class Gem
    attr_reader :line

    def initialize(line)
      @line = line.gsub(/([<>]=?)\s/, '\1')
      @parts = @line.split(/\s+/)
      @opts = {}
    end

    def install!
      return unless name
      Installer.new(self).perform!
    end

    def installed?
      if installed = Gemifest.all.detect { |line| line.include?(name) }
        return true unless version
        op = (version.match(/([<>]=?)/) || ['=='])[0]
        Version.new(installed).send(op, Version.new(version))
      end
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
