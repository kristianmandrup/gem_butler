require 'spec_helper'

describe GemButler do
  subject { butler }

  let(:butler) { GemButler.new path }

  let(:path)  { File.join File.dirname(__FILE__), 'app/gemfiles' }

  context "none excluded" do
    its(:gemfile_names) { should include('Assets', 'Bootstrap', 'DataStore', 'Facebook')}
  end

  context "assets excluded" do
    before do
      subject.exclude = [:assets] 
    end

    its(:exclude)         { should include(:assets) }
    its(:only_included?)  { should_not be_true }
    its(:only_included)   { should be_empty }
    its(:excluded)        { should_not be_empty }
    its(:gemfile_names)   { should_not include('Assets') }
  end
end
