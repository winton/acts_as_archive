class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def pulse
    render :text => '1'
  end
end