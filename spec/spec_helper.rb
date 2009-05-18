require 'rubygems'
require 'spec'
require 'rr'

require File.dirname(__FILE__) + '/../lib/gemifest'

Spec::Runner.configure { |c| c.mock_with(:rr) }

def stub_gem_list(*gems)
  list = gems.join("\n")
  stub(File).read('.gems') { list }
end

def new_gem(line)
  Gemifest::Gem.new(line)
end

def new_gemifest
  Gemifest::Runner.new('.gems')
end