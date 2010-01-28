require File.expand_path("#{File.dirname(__FILE__)}/../require")
Require.spec_helper!

Spec::Runner.configure do |config|
  $db, $log, $mail = ActiveWrapper.new(
    :base => File.dirname(__FILE__),
    :env => ENV['ENV']
  )
  $db.establish_connection
end