$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/acts_as_archive/gems"

ActsAsArchive::Gems.require(:spec)

require "#{$root}/lib/acts_as_archive"
require 'pp'

Spec::Runner.configure do |config|
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end