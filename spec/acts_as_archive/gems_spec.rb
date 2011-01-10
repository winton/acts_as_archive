require 'spec_helper'

describe ActsAsArchive::Gems do
  
  before(:each) do
    @old_config = ActsAsArchive::Gems.config
    
    ActsAsArchive::Gems.config.gemspec = "#{$root}/spec/fixtures/gemspec.yml"
    ActsAsArchive::Gems.config.gemsets = [
      "#{$root}/spec/fixtures/gemsets.yml"
    ]
    ActsAsArchive::Gems.config.warn = true
    
    ActsAsArchive::Gems.gemspec true
    ActsAsArchive::Gems.gemset = nil
  end
  
  after(:each) do
    ActsAsArchive::Gems.config = @old_config
  end
  
  describe :activate do
    it "should activate gems" do
      ActsAsArchive::Gems.stub!(:gem)
      ActsAsArchive::Gems.should_receive(:gem).with('rspec', '=1.3.1')
      ActsAsArchive::Gems.should_receive(:gem).with('rake', '=0.8.7')
      ActsAsArchive::Gems.activate :rspec, 'rake'
    end
  end
  
  describe :gemset= do
    before(:each) do
      ActsAsArchive::Gems.config.gemsets = [
        {
          :name => {
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
          :name => {
            :rake => ">0.8.6",
            :default => {
              :externals => '=1.0.2',
              :mysql => "=2.8.1",
              :rspec => "=1.3.1"
            },
            :rspec2 => {
              :mysql2 => "=0.2.6",
              :rspec => "=2.3.0"
            },
            :solo => nil
          }
        }
      end
    
      it "should set Gems.versions" do
        ActsAsArchive::Gems.versions.should == {
          :externals => "=1.0.2",
          :mysql => "=2.8.1",
          :rake => ">0.8.6",
          :rspec => "=1.3.1"
        }
      end
      
      it "should return proper values for Gems.dependencies" do
        ActsAsArchive::Gems.dependencies.should == [ :rake, :mysql ]
        ActsAsArchive::Gems.development_dependencies.should == []
      end
      
      it "should return proper values for Gems.gemset_names" do
        ActsAsArchive::Gems.gemset_names.should == [ :default, :rspec2, :solo ]
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
          :name => {
            :rake => ">0.8.6",
            :default => {
              :externals => '=1.0.2',
              :mysql => "=2.8.1",
              :rspec => "=1.3.1"
            },
            :rspec2 => {
              :mysql2=>"=0.2.6",
              :rspec => "=2.3.0"
            },
            :solo => nil
          }
        }
      end
    
      it "should set Gems.versions" do
        ActsAsArchive::Gems.versions.should == {
          :mysql2 => "=0.2.6",
          :rake => ">0.8.6",
          :rspec => "=2.3.0"
        }
      end
      
      it "should return proper values for Gems.dependencies" do
        ActsAsArchive::Gems.dependencies.should == [ :rake, :mysql2 ]
        ActsAsArchive::Gems.development_dependencies.should == []
      end
      
      it "should return proper values for Gems.gemset_names" do
        ActsAsArchive::Gems.gemset_names.should == [ :default, :rspec2, :solo ]
      end
    end
    
    describe :solo do
      before(:each) do
        ActsAsArchive::Gems.gemset = :solo
      end
      
      it "should set @gemset" do
        ActsAsArchive::Gems.gemset.should == :solo
      end
    
      it "should set @gemsets" do
        ActsAsArchive::Gems.gemsets.should == {
          :name => {
            :rake => ">0.8.6",
            :default => {
              :externals => '=1.0.2',
              :mysql => "=2.8.1",
              :rspec => "=1.3.1"
            },
            :rspec2 => {
              :mysql2=>"=0.2.6",
              :rspec => "=2.3.0"
            },
            :solo => nil
          }
        }
      end
    
      it "should set Gems.versions" do
        ActsAsArchive::Gems.versions.should == {:rake=>">0.8.6"}
      end
      
      it "should return proper values for Gems.dependencies" do
        ActsAsArchive::Gems.dependencies.should == [:rake]
        ActsAsArchive::Gems.development_dependencies.should == []
      end
      
      it "should return proper values for Gems.gemset_names" do
        ActsAsArchive::Gems.gemset_names.should == [ :default, :rspec2, :solo ]
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
  
  describe :gemset_from_loaded_specs do
    before(:each) do
      Gem.stub!(:loaded_specs)
    end
    
    it "should return the correct gemset for name gem" do
      Gem.should_receive(:loaded_specs).and_return({ "name" => nil })
      ActsAsArchive::Gems.send(:gemset_from_loaded_specs).should == :default
    end
    
    it "should return the correct gemset for name-rspec gem" do
      Gem.should_receive(:loaded_specs).and_return({ "name-rspec2" => nil })
      ActsAsArchive::Gems.send(:gemset_from_loaded_specs).should == :rspec2
    end
  end
  
  describe :reload_gemspec do
    it "should populate @gemspec" do
      ActsAsArchive::Gems.gemspec.hash.should == {
        "name" => "name",
        "version" => "0.1.0",
        "authors" => ["Author"],
        "email" => "email@email.com",
        "homepage" => "http://github.com/author/name",
        "summary" => "Summary",
        "description" => "Description",
        "dependencies" => [
          "rake",
          { "default" => [ "mysql" ] },
          { "rspec2" => [ "mysql2" ] }
        ],
        "development_dependencies" => nil
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
      ActsAsArchive::Gems.gemspec.dependencies.should == [
        "rake",
        { "default" => ["mysql"] },
        { "rspec2" => [ "mysql2" ] }
      ]
      ActsAsArchive::Gems.gemspec.development_dependencies.should == nil
    end
  
    it "should produce a valid gemspec" do
      ActsAsArchive::Gems.gemset = :default
      gemspec = File.expand_path("../../../acts_as_archive.gemspec", __FILE__)
      gemspec = eval(File.read(gemspec), binding, gemspec)
      gemspec.validate.should == true
    end
  end
end
