require 'spec/spec_helper'

describe Gemifest do
  describe "Runner" do
    it "finds list of gems" do
      stub_gem_list('fixjour', 'rr', 'foo')
      new_gemifest.gems.map { |gem| gem.to_s } \
        .should include('fixjour', 'rr', 'foo')
    end
  end
end
