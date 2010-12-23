require 'sinatra/base'
require 'smart_asset'

class Application < Sinatra::Base
  
  set :app_file, __FILE__
  set :views, File.dirname(__FILE__)
  
  include SmartAsset::Adapters::Sinatra
  
  get '/pulse' do
    '1'
  end
end