# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  include SpecHelper
  
  def pulse
    render :text => '1'
  end
  
  def should_have_valid_schema_action
    before_each false, true
    should_have_valid_schema
    render :text => '1'
  end
  
  def should_create_records_action
    before_each false, true
    should_create_records
    render :text => '1'
  end
  
  def should_migrate_record_and_preserve_deleted_at_action
    before_each false, true
    should_migrate_record_and_preserve_deleted_at
    render :text => '1'
  end
  
  def should_emulate_delete_all_action
    before_each false, true
    should_emulate_delete_all
    render :text => '1'
  end
  
  def should_move_records_back_to_original_tables_action
    before_each false, true
    should_move_records_back_to_original_tables(params[:type])
    render :text => '1'
  end
  
  def should_move_records_to_archive_tables_action
    before_each false, true
    should_move_records_to_archive_tables(params[:type])
    render :text => '1'
  end
  
  def should_delete_records_without_archiving_action
    before_each false, true
    should_delete_records_without_archiving(params[:type])
    render :text => '1'
  end
end