require 'activitystreams'
require 'json'

class ActivitiesController < ApplicationController
  include AudienceService

  def create
    json = JSON.parse(params[:json], :symbolize_names => true)
    activity_model = json_to_activity(json)

    ActiveRecord::Base.transaction do
      a = Activity.new
      a.from_activity_model(activity_model)
      a.save!

      get_users_for_activity(activity_model).each do |user_id|
        recipient = ActivityRecipient.new
        recipient.activity = a
        recipient.osm_user_id = user_id
        recipient.save!
      end
    end

    render :text => 'OK'
  end

  def index
    user_id = params[:user_id].to_i
    activities = ActivityRecipient.find(:all, :conditions => {:osm_user_id => user_id}, :joins => :activity, :order =>
      'published_at DESC').collect {|ar| ar.activity}
    stream = activities_to_json_stream(activities)
    render :text => stream.to_json
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

  def activities_to_json_stream(activities)
    items = activities.collect do |activity|
      ActivityStreams::Activity.new(
      :published => activity.published_at,
      :actor => ActivityStreams::Object::Person.new({:objectType => activity.actor_type}),
      :object => create_object({:objectType => activity.object_type}),
      :target => create_object({:objectType => activity.target_type}),
      :verb => create_verb(activity.verb),
      :title => activity.title,
      :content => activity.content)
    end

    ActivityStreams::Stream.new(
      :items => items,
      :total_count => activities.size)
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
