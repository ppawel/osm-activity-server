require 'couchrest'
require 'json'

require './model'

module ActivityServer

  def self.readview(file)
    open("#{file}").read
  end

  # Design document for the "activities" database
  $design_doc = {
    "_id" => "_design/activities",
    "views" => {
      "activities_by_users" => {
        "map" => readview("activities_by_users.js")
      }
    }
  }

  class ActivityService
    attr_accessor :client
    attr_accessor :db

    def initialize
      @db = CouchRest.database!("http://127.0.0.1:5984/activities")
      doc = @db.get('_design/activities') rescue {}
      doc.merge!($design_doc)
      @db.save_doc(doc)
    end

    def publish_activity(json)
      activity = Activity.new(json)
      activity.published = Time.now.strftime '%Y-%m-%dT%H:%M:%S%z'
      doc = @db.save_doc(activity.to_hash)
    end

    def activity_stream_for_user(user_id)
      rows = @db.view('activities/activities_by_users', {:startkey => [user_id.to_s, ''],
        :endkey => [user_id.to_s, 'Z'], :include_docs => true})['rows']
      rows.collect {|row| Activity.new(row['doc'])}
    end
  end

  @@activity_service = ActivityService.new

  def self.service
    @@activity_service
  end
end

