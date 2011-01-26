require 'sinatra/base'
require "#{$root}/lib/acts_as_archive"

class Application < Sinatra::Base
  
  set :app_file, __FILE__
  set :dump_errors, true
  set :raise_errors, true
  set :show_exceptions, false
  
  include ActsAsArchive::Adapters::Sinatra
  include SpecHelper
  
  get '/pulse' do
    '1'
  end
  
  get "/should_have_valid_schema_action" do
    before_each false, true
    should_have_valid_schema
    '1'
  end
  
  get "/should_create_records_action" do
    before_each false, true
    should_create_records
    '1'
  end
  
  get "/should_migrate_record_and_preserve_deleted_at_action" do
    before_each false, true
    should_migrate_record_and_preserve_deleted_at
    '1'
  end
  
  get "/should_emulate_delete_all_action" do
    before_each false, true
    should_emulate_delete_all
    '1'
  end
  
  get "/should_move_records_back_to_original_tables_action" do
    before_each false, true
    should_move_records_back_to_original_tables(params[:type])
    '1'
  end
  
  get "/should_move_records_to_archive_tables_action" do
    before_each false, true
    should_move_records_to_archive_tables(params[:type])
    '1'
  end
  
  get "/should_delete_records_without_archiving_action" do
    before_each false, true
    should_delete_records_without_archiving(params[:type])
    '1'
  end
end