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
      doc = @db.get('_design/activities')
      doc = {} if !doc
      doc.merge!($design_doc)
      @db.save_doc(doc)
    end

    def publish_activity(json)
      activity = Activity.new(json)
      activity.published = Time.now.strftime '%Y-%m-%dT%H:%M:%S%z'
      puts activity.inspect
      doc = @db.save_doc(activity.to_hash)
      #puts activity.inspect
      #puts activity.to_h.inspect
      #puts JSON.generate(activity.to_hash).inspect
      #doc = @db.put json
    end
  end

  @@activity_service = ActivityService.new

  def self.service
    @@activity_service
  end
end

