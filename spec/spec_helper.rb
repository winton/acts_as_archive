$TESTING=true
SPEC = File.dirname(__FILE__)

require 'rubygems'
require 'active_record'
require 'logger'
require 'yaml'
require 'pp'

require File.expand_path("#{SPEC}/../rails/init")

Spec::Runner.configure do |config|
end

def debug(object)
  puts "<pre>"
  pp object
  puts "</pre>"
end

def establish_test_db
  # Establish connection
  unless ActiveRecord::Base.connected?
    config = YAML::load(File.open("#{SPEC}/config/database.yml"))['test']
    ActiveRecord::Base.establish_connection(config)
  end
  # Establish logger
  logger_file = File.open("#{SPEC}/log/test.log", 'a')
  logger_file.sync = true
  @logger = Logger.new logger_file
  ActiveRecord::Base.logger = @logger
  # Drop articles and archived_articles
  ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS articles")
  ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS archived_articles")
  # Create articles table
  ActiveRecord::Base.connection.create_table(:articles) do |t|
    t.string :title
    t.string :body
    t.timestamps
  end
  # Load model
  require "#{SPEC}/models/article"
end
