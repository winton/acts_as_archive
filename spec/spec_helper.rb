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

def article_match?(original, copy)
  copy.id.should == original.id
  copy.title.should == original.title
  copy.body.should == original.body
  if copy.respond_to?(:deleted_at)
    copy.deleted_at.strftime('%j%H%M').should == Time.now.strftime('%j%H%M')
  end
end

def columns(table)
  connection.columns(table).collect(&:name)
end

def connection
  ActiveRecord::Base.connection
end

def create_records(klass=Article, values={})
  articles = []
  table = klass.table_name
  cols = columns(table)
  connection.execute("DELETE FROM #{table}")
  (1..5).collect do |x|
    vals = cols.collect do |c|
      if values.keys.include?(c.intern)
        values[c.intern] ? "'#{values[c.intern]}'" : "NULL"
      else
        case c.intern
        when :id; x
        when :deleted_at; 'NULL'
        else "'#{c.capitalize} #{x}'"
        end
      end
    end
    connection.execute(%{
      INSERT INTO #{table} (#{cols.collect { |c| "`#{c}`" }.join(', ')})
        VALUES (#{vals.join(', ')})
    })
    klass.find(x)
  end
end

def debug(object)
  puts "<pre>"
  pp object
  puts "</pre>"
end

def establish_test_db
  # Establish connection
  unless ActiveRecord::Base.connected?
    config = YAML::load(File.open("#{SPEC}/db/config/database.yml"))
    ActiveRecord::Base.configurations = config
    ActiveRecord::Base.establish_connection(config['test'])
  end
  # Establish logger
  logger_file = File.open("#{SPEC}/db/log/test.log", 'a')
  logger_file.sync = true
  @logger = Logger.new(logger_file)
  ActiveRecord::Base.logger = @logger
  # Drop articles and archived_articles
  connection.execute("DROP TABLE IF EXISTS articles")
  connection.execute("DROP TABLE IF EXISTS archived_articles")
  connection.execute("DROP TABLE IF EXISTS schema_migrations")
  # Create articles table
  connection.create_table(:articles) do |t|
    t.string :title
    t.string :body
  end
  # Load model
  require "#{SPEC}/db/models/article"
end

def indexes
  query = "SHOW INDEX FROM archived_#{Article.table_name}"
  connection.select_all(query).collect do |r|
    r["Column_name"]
  end
end
