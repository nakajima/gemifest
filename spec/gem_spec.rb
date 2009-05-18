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
end