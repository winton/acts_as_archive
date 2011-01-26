require 'pp'

$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/acts_as_archive/gems"

ActsAsArchive::Gems.activate :framework_fixture
require 'framework_fixture'

if FrameworkFixture.framework == 'rails'
  ENV['RAILS_ENV'] = 'test'
  FrameworkFixture.generate File.dirname(__FILE__) + '/fixtures'
end

ActsAsArchive::Gems.activate %w(active_wrapper-solo rack-test rspec)
require 'active_wrapper/gems'

# Framework specs
if FrameworkFixture.framework
  require 'rack/test'
  
  if FrameworkFixture.rails == '<3'
    ActiveWrapper::Gems.gemset = :ar2
  elsif FrameworkFixture.sinatra
    ActiveWrapper::Gems.activate %w(activesupport)
    require 'active_support/dependencies'
    ActiveSupport::Dependencies.autoload_paths << "#{$root}/spec/fixtures/builds/sinatra#{ENV['SINATRA']}/app/models"
    ActiveSupport::Dependencies.autoload_paths << "#{$root}/spec/fixtures/builds/sinatra#{ENV['SINATRA']}/app/helpers"
  end
  
  require 'active_wrapper'

# Normal specs
else
  if ENV['ACTIVERECORD'] == '2'
    ActiveWrapper::Gems.gemset = :ar2
  else
    ActiveWrapper::Gems.activate %w(activesupport)
    require 'active_support/dependencies'
  end
  
  require 'active_wrapper'
  
  require "#{$root}/lib/acts_as_archive"

  ActiveSupport::Dependencies.autoload_paths << "#{$root}/spec/fixtures/models"
  ActiveSupport::Dependencies.autoload_paths << "#{$root}/spec/fixtures/helpers"
  
  include SpecHelper
end

$db, $log, $mail = ActiveWrapper.setup(
  :adapter => ActiveWrapper::Gems.gemset == :ar2 ? 'mysql' : 'mysql2',
  :base => "#{$root}/spec/fixtures",
  :env => 'test'
)
$db.establish_connection

unless FrameworkFixture.framework
  ActsAsArchive.load_from_yaml("#{$root}/spec/fixtures")
end

if FrameworkFixture.framework == 'sinatra'
  FrameworkFixture.generate File.dirname(__FILE__) + '/fixtures'
end

Spec::Runner.configure do |config|
end

def before_each(migrate=true, setup=true)
  if migrate
    [ 8, 0, 8 ].each { |v| $db.migrate(v) }
    Record.reset_column_information
  end
  if setup
    @record, @lengths, @zero_lengths = setup_records
  end
end