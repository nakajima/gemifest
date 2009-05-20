module Gemifest
  def self.all(reload=false)
    @all = nil if reload
    @all ||= begin
      begin
        list = `gem list`
      ensure
        # $stdout = STDOUT
      end
      list.split(/\n/)
    end
  end

  class Gem
    class Version
      def initialize(line)
        @line = line
      end

      def digits
        to_s.split('.').map { |d| d.to_i }
      end

      def ==(other)
        digits == other.digits
      end

      def >(other)
        digits.each_with_index do |num, i|
          return true if num > other.digits[i]
        end ; false
      end

      def <(other)
        digits.each_with_index do |num, i|
          return true if num < other.digits[i]
        end ; false
      end

      def >=(other)
        digits.each_with_index do |num, i|
          return false if num < other.digits[i]
        end or true
      end

      def <=(other)
        digits.each_with_index do |num, i|
          return false if num > other.digits[i]
        end or true
      end

      def to_s
        @line.scan(/\(?([\d\.]+)[\),]?/).first.to_s
      end

      def value
        total = 0
        to_s.scan(/\d+/).flatten.reverse.each_with_index do |num, i|
          total += num.to_i * ((i + 1) * 10)
        end ; total
      end
    end

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

    def version_value(version)
      total = 0
      version.to_s.scan(/\d+/).flatten.reverse.each_with_index do |num, i|
        total += num.to_i * (i * 10)
      end ; total
    end

    def get(name)
      if val = @opts[name]
        val.to_s.gsub(/"|'/, '')
      end
    end
  end
end
