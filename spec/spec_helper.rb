$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/acts_as_archive/gems"

ActsAsArchive::Gems.require(:spec_first)

require 'framework_fixture'
FrameworkFixture.generate File.dirname(__FILE__) + '/fixtures'

ActsAsArchive::Gems.require(:spec)

if FrameworkFixture.framework
  require 'rack/test'
else
  ActsAsArchive::Gems.require(:spec_non_framework)
  
  require 'active_support/dependencies'
  require 'active_wrapper'
  
  require "#{$root}/lib/acts_as_archive"

  ActiveSupport::Dependencies.autoload_paths << "#{$root}/spec/fixtures/models"

  $db, $log, $mail = ActiveWrapper.setup(
    :base => "#{$root}/spec/fixtures",
    :env => 'test'
  )
  $db.establish_connection
end

ActiveSupport::Dependencies.autoload_paths << "#{$root}/spec/fixtures/helpers"

include SpecHelper

Spec::Runner.configure do |config|
end