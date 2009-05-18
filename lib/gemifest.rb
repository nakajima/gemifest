require 'rubygems'
require 'nakajima'
require 'optparse'

$LOAD_PATH << File.dirname(__FILE__)

require 'gemifest/gem'

module Gemifest
  def self.run(command)
    `gem #{command}`
  end

  class Runner
    def initialize(path)
      @path = path
    end

    def list
      gems.each { |gem| puts gem }
    end

    def install
      gems.each { |gem| gem.install! }
    end

    def gems
      @gems ||= File.read(@path).map { |line| Gem.new(line).parse! }
    end
  end
end
