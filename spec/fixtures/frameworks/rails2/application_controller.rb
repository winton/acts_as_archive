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