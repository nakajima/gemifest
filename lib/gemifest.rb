require 'rubygems'
require 'colored'
require 'optparse'

$LOAD_PATH << File.dirname(__FILE__)

require 'gemifest/installer'
require 'gemifest/version'
require 'gemifest/gem'

module Gemifest
  class Runner
    def initialize(path)
      @path = path
    end

    def help
      puts "Gemifest Commands:"
      puts "- help (show this message)"
      puts "- list (show gems in gemifest)"
      puts "- install (install gems in gemifest)"
    end

    def list
      Gemifest.all(true)
      puts "Listing gems:"
      puts
      missing = []
      gems.each do |gem|
        print '['
        print gem.installed? ? 'ok'.green : '  '.red
        print '] '
        puts gem
        missing << gem.line unless gem.installed?
      end
      puts
      if missing.empty?
        puts "All gems installed!".bold
      else
        puts "Missing gems:".bold
        puts missing
      end
    end

    def install
      gems.each { |gem| gem.install! }
    end

    def method_missing(sym)
      puts "Invalid command: #{sym}"
      puts
      help
    end

    def gems
      @gems ||= File.read(@path).map { |line| Gem.new(line).parse! }
    end
  end
end
