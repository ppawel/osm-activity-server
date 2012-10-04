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
