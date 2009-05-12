require 'spec/spec_helper'

describe Gemifest do
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

  describe "Runner" do
    it "finds list of gems" do
      stub_gem_list('fixjour', 'rr', 'foo')
      new_gemifest.gems.should include('fixjour', 'rr', 'foo')
    end
  end

  describe "Gem" do
    it "returns name" do
      new_gem('fixjour').name.should == 'fixjour'
    end

    it "raises invalid options" do
      proc {
        new_gem('fixjour --foo')
      }.should raise_error(OptionParser::InvalidOption)
    end

    it "finds version" do
      new_gem('fixjour --version ">= 0.1.2"').version.should == '>=0.1.2'
      new_gem('fixjour --version=">= 0.1.2"').version.should == '>=0.1.2'
    end

    it "finds source" do
      source = new_gem('fixjour --source=http://gems.github.com').source
      source.should == "http://gems.github.com"

      source = new_gem('fixjour --source http://gems.github.com').source
      source.should == "http://gems.github.com"
    end
  end
end
