require 'spec_helper'

describe GemButler do
  subject { butler }

  let(:butler) { GemButler.new path }

  let(:path)  { File.join File.dirname(__FILE__), 'app/gemfiles' }

  describe 'self.camelize' do
    it 'should camelize' do
      GemButler.camelize(:data_store).should == 'DataStore'
    end
  end

  context "none excluded" do
    its(:gemfile_names) { should include('Assets', 'Bootstrap', 'DataStore', 'Facebook')}
  end

  context "excluded assets" do
    before do
      subject.excluded_names = [:assets] 
    end

    its(:excluded_names)   { should include(:assets) }
    its(:only_included?)  { should_not be_true }
    its(:only_included)   { should be_empty }
    its(:after_exclude)   { should_not be_empty }
    specify { subject.exclude_list.first.should match /Assets\.gemfile/ }
    its(:gemfile_names)   { should_not include('Assets') }
  end

  context "include only assets" do
    before do
      subject.excluded_names = []
      subject.include_only_names = [:assets, :data_store] 
    end

    its(:include_only_names)    { should include(:assets, :data_store) }
    its(:only_included?)  { should be_true }
    its(:only_included)   { should have(2).items }
    its(:after_exclude)   { should_not be_empty }    
    its(:gemfile_names)   { should include('Assets', 'DataStore') }
    its(:gemfile_names)   { should_not include('Bootstrap') }
  end

  context "include only view folder" do
    before do
      subject.include_only_folders = [:view] 
    end

    its(:include_only_folders)   { should include(:view) }
    its(:only_included_folders?) { should be_true }
    its(:only_included_folders)  { should have(1).item }
    specify { subject.only_included_folders.first.should match('view/Bootstrap') }

    its(:filtered)        { should have(1).item }
    its(:gemfile_names)   { should include('Bootstrap') }
    its(:gemfile_names)   { should_not include('Assets') }
  end

  context "exclude view folder" do
    before do
      subject.excluded_folders = [:view] 
    end

    its(:excluded_folders)         { should include(:view) }
    its(:excluded_folders)         { should have(1).item }
    its(:only_included_folders?)  { should be_false }

    its(:gemfile_names)   { should_not include('Bootstrap') }
    its(:gemfile_names)   { should include('DataStore') }
  end

  context "exclude view folder using option" do
    before do
      subject.exclude :folders => :view
    end

    its(:gemfile_names)   { should_not include('Bootstrap') }
    its(:gemfile_names)   { should include('DataStore') }
  end

  context "include view folder using option" do
    before do
      subject.include_only :folders => :view, :names => :facebook
    end

    its(:gemfile_names)   { should be_empty }
  end

  context "include /view folder and then :facebook via select names" do
    before do
      subject.include_only :folders => :view
      subject.selected_names = :facebook
    end

    its(:gemfile_names)   { should include('Bootstrap', 'Facebook') }
  end

  context 'select names via #select' do
    before do
      subject.include_only :folders => :view
      subject.select :facebook
    end

    its(:gemfile_names)   { should include('Bootstrap', 'Facebook') }
  end
end
