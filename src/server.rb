require 'json'
require 'sinatra'

require './service'

post '/activity/new' do
  json = JSON.parse(params[:json])
  #puts json.inspect
  ActivityServer::service.publish_activity(json)
end

