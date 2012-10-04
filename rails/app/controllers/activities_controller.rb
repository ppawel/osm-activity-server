require 'activitystreams'
require 'json'

class ActivitiesController < ApplicationController
  def create
    json = JSON.parse(params[:json], :symbolize_names => true)
    activity_model = json_to_activity(json)
    puts activity_model.inspect
    a = Activity.new
    a.from_activity_model(activity_model)
    a.save!

    render :text => 'OK'
  end

  protected

  def json_to_activity(json)
    ActivityStreams::Activity.new(
      :published => Time.now.utc,
      :actor => ActivityStreams::Object::Person.new(json[:actor]),
      :object => create_object(json[:object]),
      :target => create_object(json[:target]),
      :verb => create_verb(json[:verb]),
      :title => json[:title],
      :content => json[:content])
  end

  def create_object(attributes)
    cls = Object.const_get('ActivityStreams').const_get('Object').const_get(attributes[:objectType].camelize)
    cls.new(attributes)
  end

  def create_verb(verb)
    cls = Object.const_get('ActivityStreams').const_get('Verb').const_get(verb.camelize)
    cls.new
  end
end
