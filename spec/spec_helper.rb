$testing = true
SPEC = File.dirname(__FILE__)

$:.unshift SPEC
$:.unshift File.expand_path("#{SPEC}/../lib")

require 'gem_template'
require 'pp'

require 'rubygems'
require 'active_wrapper'

Spec::Runner.configure do |config|
  $db, $log, $mail = ActiveWrapper.new(
    :base => File.dirname(__FILE__),
    :env => ENV['ENV']
  )
  $db.establish_connection
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end
