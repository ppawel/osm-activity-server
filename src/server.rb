require 'json'
require 'sinatra'

require './service'

post '/activity/new' do
  json = JSON.parse(params[:json])
  ActivityServer::service.publish_activity(json)
end

get '/activity/user/:id' do
  user_id = params[:id].to_i
  activities = ActivityServer::service.activity_stream_for_user(user_id)
  JSON.pretty_generate(activities.collect {|activity| activity.to_hash})
end

