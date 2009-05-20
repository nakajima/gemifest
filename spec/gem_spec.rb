require 'spec/spec_helper'

describe Gemifest::Gem do
  it "returns name" do
    new_gem('fixjour').parse!.name.should == 'fixjour'
  end

  it "raises invalid options" do
    proc {
      new_gem('fixjour --foo').parse!
    }.should raise_error(OptionParser::InvalidOption)
  end

  it "finds version" do
    new_gem('fixjour --version ">= 0.1.2"').parse!.version.should == '>=0.1.2'
    new_gem('fixjour --version=">= 0.1.2"').parse!.version.should == '>=0.1.2'
  end

  it "finds source" do
    new_gem('fixjour --source=http://gems.github.com').parse! \
      .source.should == "http://gems.github.com"
    source = new_gem('fixjour --source http://gems.github.com').parse! \
      .source.should == "http://gems.github.com"
  end
  
  describe "Version" do
    it "gets version" do
      version = Gemifest::Gem::Version.new('fixjour (1.2.3)')
      version.to_s.should == '1.2.3'
    end
    
    it "finds value" do
      version = Gemifest::Gem::Version.new('fixjour (1.2.3)')
      version.value.should == 3*10 + 2*20 + 1*30
    end
  end
  
  describe "installed?" do
    it "is not if gem isn't in list" do
      stub(Gemifest).all { 'foo (0.0.1)' }
      new_gem('fixjour').parse!.should_not be_installed
    end
    
    it "is if no version" do
      stub(Gemifest).all { 'fixjour (0.0.1)' }  
      new_gem('fixjour').parse!.should be_installed
    end
    
    it "is if equal version" do
      stub(Gemifest).all { 'fixjour (0.1.1)' }
      gem = new_gem('fixjour --version 0.1.1').parse!
      gem.should be_installed
    end
    
    it "is if greater version allowed" do
      stub(Gemifest).all { 'fixjour (0.1.2)' }
      gem = new_gem('fixjour --version >= 0.1.1').parse!
      gem.should be_installed
    end
    
    it "is if lesser version allowed" do
      stub(Gemifest).all { 'fixjour (0.0.9)' }
      gem = new_gem('fixjour --version "< 0.1.0"').parse!
      gem.should be_installed
    end
    
    it "is not if version not equal" do
      stub(Gemifest).all { 'fixjour (0.0.1)' }
      gem = new_gem('fixjour --version 0.1.0').parse!
      gem.should_not be_installed
    end
    
    it "is not if version is not enough" do
      stub(Gemifest).all { 'fixjour (0.0.1)' }
      gem = new_gem('fixjour --version ">= 0.1.1"').parse!
      gem.should_not be_installed
    end
    
    it "is not if version too much" do
      stub(Gemifest).all { 'fixjour (0.1.1)' }
      gem = new_gem('fixjour --version < 0.1.0').parse!
      gem.should_not be_installed
    end
  end
end