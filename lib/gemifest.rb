require 'rubygems'
require 'nakajima'
require 'optparse'

module Gemifest
  def self.run(command)
    `gem #{command}`
  end

  class Gem
    def initialize(line)
      @line = line.gsub(/((?:<|>)?=)\s/, '\1')
      @parts = @line.split(/\s+/)
      @opts = {}
      parse!
    end

    def version
      option :version
    end

    def source
      option :source
    end

    def name
      @parts.first
    end

    private

    def option(name)
      if val = @opts[name]
        val.to_s.gsub(/"|'/, '')
      end
    end

    def parse!
      OptionParser.new do |opts|
        opts.on("-s", "--source SOURCE")   { |s| @opts[:source] = s }
        opts.on("-v", "--version VERSION") { |v| @opts[:version] = v }
      end.parse!(@parts)
    end
  end

  class Runner
    def initialize(path)
      @path = path
    end

    def gems
      File.read(@path).split("\n")
    end
  end
end
