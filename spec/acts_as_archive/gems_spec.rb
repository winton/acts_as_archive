require 'spec_helper'

describe ActsAsArchive::Gems do
  
  describe :activate do
    before(:each) do
      ActsAsArchive::Gems.configs = [
        "#{$root}/spec/fixtures/gemsets.yml"
      ]
      ActsAsArchive::Gems.gemset = nil
      ActsAsArchive::Gems.testing = true
    end
    
    it "should warn if unable to require rubygems" do
      ActsAsArchive::Gems.stub!(:require)
      ActsAsArchive::Gems.should_receive(:require).with('rubygems').and_raise(LoadError)
      ActsAsArchive::Gems.stub!(:gem)
      out = capture_stdout do
        ActsAsArchive::Gems.activate :rspec
      end
      out.should =~ /rubygems library could not be required/
    end
    
    it "should activate gems" do
      ActsAsArchive::Gems.stub!(:gem)
      ActsAsArchive::Gems.should_receive(:gem).with('rspec', '=1.3.1')
      ActsAsArchive::Gems.should_receive(:gem).with('rake', '=0.8.7')
      ActsAsArchive::Gems.activate :rspec, 'rake'
    end
  end
  
  describe :gemset= do
    before(:each) do
      ActsAsArchive::Gems.configs = [
        {
          :gem_template => {
            :rake => '>0.8.6',
            :default => {
              :externals => '=1.0.2'
            }
          }
        },
        "#{$root}/spec/fixtures/gemsets.yml"
      ]
    end
    
    describe :default do
      before(:each) do
        ActsAsArchive::Gems.gemset = :default
      end
      
      it "should set @gemset" do
        ActsAsArchive::Gems.gemset.should == :default
      end
    
      it "should set @gemsets" do
        ActsAsArchive::Gems.gemsets.should == {
          :gem_template => {
            :rake => ">0.8.6",
            :default => {
              :externals => '=1.0.2',
              :rspec => "=1.3.1"
            },
            :rspec2 => { :rspec => "=2.3.0" }
          }
        }
      end
    
      it "should set Gems.versions" do
        ActsAsArchive::Gems.versions.should == {
          :rake => ">0.8.6",
          :rspec => "=1.3.1",
          :externals => "=1.0.2"
        }
      end
    
      it "should set everything to nil if gemset given nil value" do
        ActsAsArchive::Gems.gemset = nil
        ActsAsArchive::Gems.gemset.should == nil
        ActsAsArchive::Gems.gemsets.should == nil
        ActsAsArchive::Gems.versions.should == nil
      end
    end
    
    describe :rspec2 do
      before(:each) do
        ActsAsArchive::Gems.gemset = "rspec2"
      end
      
      it "should set @gemset" do
        ActsAsArchive::Gems.gemset.should == :rspec2
      end
    
      it "should set @gemsets" do
        ActsAsArchive::Gems.gemsets.should == {
          :gem_template => {
            :rake => ">0.8.6",
            :default => {
              :externals => '=1.0.2',
              :rspec => "=1.3.1"
            },
            :rspec2 => { :rspec => "=2.3.0" }
          }
        }
      end
    
      it "should set Gems.versions" do
        ActsAsArchive::Gems.versions.should == {
          :rake => ">0.8.6",
          :rspec => "=2.3.0"
        }
      end
    end
    
    describe :nil do
      before(:each) do
        ActsAsArchive::Gems.gemset = nil
      end
      
      it "should set everything to nil" do
        ActsAsArchive::Gems.gemset.should == nil
        ActsAsArchive::Gems.gemsets.should == nil
        ActsAsArchive::Gems.versions.should == nil
      end
    end
  end
  
  describe :reload_gemspec do
    before(:all) do
      ActsAsArchive::Gems.configs = [
        "#{$root}/spec/fixtures/gemsets.yml"
      ]
      ActsAsArchive::Gems.gemset = :default
    end
  
    before(:each) do
      @gemspec_path = "#{$root}/gem_template.gemspec"
      @gemspec = File.read(@gemspec_path)
      yml = File.read("#{$root}/spec/fixtures/gemspec.yml")
      File.stub!(:read).and_return yml
      ActsAsArchive::Gems.reload_gemspec
    end
  
    it "should populate @gemspec" do
      ActsAsArchive::Gems.gemspec.hash.should == {
        "name" => "name",
        "version" => "0.1.0",
        "authors" => ["Author"],
        "email" => "email@email.com",
        "homepage" => "http://github.com/author/name",
        "summary" => "Summary",
        "description" => "Description",
        "dependencies" => ["rake"],
        "development_dependencies" => ["rspec"]
       }
    end
  
    it "should create methods from keys of @gemspec" do
      ActsAsArchive::Gems.gemspec.name.should == "name"
      ActsAsArchive::Gems.gemspec.version.should == "0.1.0"
      ActsAsArchive::Gems.gemspec.authors.should == ["Author"]
      ActsAsArchive::Gems.gemspec.email.should == "email@email.com"
      ActsAsArchive::Gems.gemspec.homepage.should == "http://github.com/author/name"
      ActsAsArchive::Gems.gemspec.summary.should == "Summary"
      ActsAsArchive::Gems.gemspec.description.should == "Description"
      ActsAsArchive::Gems.gemspec.dependencies.should == ["rake"]
      ActsAsArchive::Gems.gemspec.development_dependencies.should == ["rspec"]
    end
  
    it "should produce a valid gemspec" do
      gemspec = eval(@gemspec, binding, @gemspec_path)
      gemspec.validate.should == true
    end
  end
end
