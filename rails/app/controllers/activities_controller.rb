require 'activitystreams'
require 'json'

class ActivitiesController < ApplicationController
  def create
    json = JSON.parse(params[:json], :symbolize_names => true)
    puts json.inspect
    puts ActivityStreams::Object::Person.new(json[:actor]).inspect
    render :text => 'OK'
  end
end
