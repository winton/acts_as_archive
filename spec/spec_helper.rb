$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/gem_template/gems"

GemTemplate::Gems.activate %w(active_wrapper rspec)

require 'active_wrapper'

require "#{$root}/lib/gem_template"
require 'pp'

Spec::Runner.configure do |config|
end

$db, $log, $mail = ActiveWrapper.setup(
  :base => File.dirname(__FILE__),
  :env => 'test'
)
$db.establish_connection

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end