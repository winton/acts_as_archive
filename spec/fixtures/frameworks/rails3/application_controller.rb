class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include SpecHelper
  
  def pulse
    render :text => '1'
  end
  
  def should_create_records_action
    before_each false, true
    should_create_records
    render :text => '1'
  end
  
  def should_move_records_back_to_original_tables_action
    before_each false, true
    should_move_records_back_to_original_tables
    render :text => '1'
  end
  
  def should_move_records_to_archive_tables_action
    before_each false, true
    should_move_records_to_archive_tables(params[:type])
    render :text => '1'
  end
end