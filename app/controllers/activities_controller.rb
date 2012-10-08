require 'activitystreams'
require 'json'
require 'rss'
require 'osm_activity_server'

##
# Responsible for handling all actions related to activities. Activity is configured as a standard Rails resource in
# routes.rb which means that {standard RESTful URLs are mapped to this controller's actions}[http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions].
#
class ActivitiesController < ApplicationController
  include AudienceService
  include ActivityServerLogger

  ##
  # Handles creating an activity.
  #
  def create
    response_json = nil

    begin
      json = JSON.parse(params[:json], :symbolize_names => true)
      activity_item = json_to_activity_item(json)

      ActiveRecord::Base.transaction do
        a = Activity.new
        a.from_activity_item(activity_item)
        a.save

        get_users_for_activity(activity_item).each do |user_id|
          # There can be a lot of recipients so let's do raw SQL.
          # A little bit of premature optimization hasn't killed anyone, right? :-)
          ActivityRecipient.connection.execute "INSERT INTO activity_recipients (osm_user_id, activity_id) VALUES (#{user_id}, #{a.id})"
        end
      end

      response_json = activity_item.to_json
    rescue Exception => e
      puts e.message
      puts e.backtrace
      response_json = "{\"error\": \"#{e.class.name}: #{e.message}\"}"
    end

    render :json => response_json
  end

  ##
  # Handles listing activities by various criteria.
  #
  def index
    format = params[:format]
    format ||= 'json'
    user_id = params[:user_id]

    if user_id.nil?
      render :json => "{\"error\": \"Missing request parameter: user_id\"}"
      return
    end

    @activities = find_activities_by_actor(user_id)

    if format == 'json'
      stream = activities_to_json_stream(@activities)
      render :json => stream.to_json
    elsif format == 'rss'
      render :rss => stream.to_json
    end
  end

  protected

  def find_activities_by_actor(user_id)
    Activity.find(:all,
      :conditions => {:actor_id => user_id},
      :order => 'published_at DESC')
  end

  def find_activities_for_recipient(user_id)
    ActivityRecipient.find(:all,
      :conditions => {:osm_user_id => user_id},
      :joins => :activity,
      :include => :activity,
      :order => 'published_at DESC').collect {|ar| ar.activity}
  end

  def json_to_activity_item(json)
    object = create_object(json[:object])
    target = create_object(json[:target])
    verb = create_verb(json[:verb])

    ActivityStreams::Activity.new(
      :published => Time.now.utc,
      :actor => ActivityStreams::Object::Person.new(json[:actor]),
      :object => object,
      :target => target,
      :verb => verb,
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
