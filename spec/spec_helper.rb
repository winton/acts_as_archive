$testing = true
SPEC = File.dirname(__FILE__)

require 'pp'
require File.expand_path("#{SPEC}/../rails/init")

Spec::Runner.configure do |config|
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end
