$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/acts_as_archive/gems"

ActsAsArchive::Gems.require(:spec)

require 'active_support/dependencies'
require 'active_wrapper'
require "#{$root}/lib/acts_as_archive"

ActiveSupport::Dependencies.autoload_paths << "#{$root}/spec/fixtures"

$db, $log, $mail = ActiveWrapper.setup(
  :base => File.dirname(__FILE__),
  :env => 'test'
)
$db.establish_connection

Dir["#{$root}/spec/fixtures/*.rb"].each do |path|
  require path
end

require 'pp'

Spec::Runner.configure do |config|
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end