require File.expand_path("#{File.dirname(__FILE__)}/../require")
Require.spec_helper!

Spec::Runner.configure do |config|
end

$db, $log, $mail = ActiveWrapper.new(
  :base => File.dirname(__FILE__),
  :env => 'test'
)
$db.establish_connection