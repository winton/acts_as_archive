require 'rubygems'
gem 'require'
require 'require'

Require File.dirname(__FILE__) do
  gem(:activerecord) { require 'active_record' }
  gem :require, '=0.1.8'
  gem(:rake, '=0.8.7') { require 'rake' }
  gem :rspec, '=1.3.0'
  
  gemspec do
    author 'Winton Welsh'
    dependencies do
      gem :require
    end
    email 'mail@wintoni.us'
    name 'acts_as_archive'
    homepage "http://github.com/winton/#{name}"
    summary "Don't delete your records, move them to a different table"
    version '0.2.0'
  end
  
  lib do
    require "lib/acts_as_archive/base"
    require "lib/acts_as_archive/base/destroy"
    require "lib/acts_as_archive/base/restore"
    require "lib/acts_as_archive/base/table"
    require "lib/acts_as_archive/migration"
  end
  
  rails_init { require 'lib/acts_as_archive' }
  
  rakefile do
    gem(:rake) { require 'rake/gempackagetask' }
    gem(:rspec) { require 'spec/rake/spectask' }
    require 'require/tasks'
  end
  
  spec_helper do
    require 'require/spec_helper'
    gem :activerecord
    require 'logger'
    require 'yaml'
    require 'pp'
    require 'rails/init'
  end
end