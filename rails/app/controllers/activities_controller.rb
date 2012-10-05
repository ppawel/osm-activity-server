require 'activitystreams'
require 'json'
require 'osm_activity_server'

##
# Responsible for handling all actions related to activities. Activity is configured as a standard Rails resource in
# routes.rb which means that {standard RESTful URLs are mapped to this controller's actions}[http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions].
#
class ActivitiesController < ApplicationController
  include AudienceService

  ##
  # Handles creating an activity.
  #
  def create
    json = JSON.parse(params[:json], :symbolize_names => true)
    activity_item = json_to_activity_item(json)

    ActiveRecord::Base.transaction do
      a = Activity.new
      a.from_activity_item(activity_item)
      a.save!

      get_users_for_activity(activity_item).each do |user_id|
        recipient = ActivityRecipient.new
        recipient.activity = a
        recipient.osm_user_id = user_id
        recipient.save!
      end
    end

    render :json => activity_item.to_json
  end

  def index
    user_id = params[:user_id].to_i
    activities = ActivityRecipient.find(:all,
      :conditions => {:osm_user_id => user_id},
      :joins => :activity,
      :include => :activity,
      :order => 'published_at DESC').collect {|ar| ar.activity}
    stream = activities_to_json_stream(activities)
    render :json => stream.to_json
  end

  protected

  def json_to_activity_item(json)
    ActivityStreams::Activity.new(
      :published => Time.now.utc,
      :actor => ActivityStreams::Object::Person.new(json[:actor]),
      :object => create_object(json[:object]),
      :target => create_object(json[:target]),
      :verb => create_verb(json[:verb]),
      :title => json[:title],
      :content => json[:content],
      :to => json[:to].collect {|object_attrs| create_object(object_attrs)})
  end

  def activities_to_json_stream(activities)
    items = activities.collect do |activity|
      ActivityStreams::Activity.new(
        :published => activity.published_at,
        :actor => create_object({
          :objectType => activity.actor_type,
          :id => activity.actor_id,
          :display_name => activity.actor_display_name,
          :url => activity.actor_url
        }),
        :object => create_object({
          :objectType => activity.object_type,
          :id => activity.object_id,
          :display_name => activity.object_display_name,
          :url => activity.object_url
        }),
        :target => create_object({
          :objectType => activity.target_type,
          :id => activity.target_id,
          :display_name => activity.target_display_name,
          :url => activity.target_url
        }),
        :verb => create_verb(activity.verb),
        :title => activity.title,
        :content => activity.content)
    end

    ActivityStreams::Stream.new(:items => items, :total_count => items.size)
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
