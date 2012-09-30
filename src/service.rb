require 'couchdb-client'
require 'json'

require './model'

module ActivityServer

  def self.readview(file)
    open("#{file}").read
  end

  # Design document for the "activities" database
  $design = {
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
      @client = CouchDB.connect(:host => 'localhost', :port => 5984)
      @client.put('activities') rescue nil
      @db = client['activities']
      doc = @db.find('_design/activities')
      @db.delete('_design/activities', doc['_rev']) if doc
      @db.put($design)
    end

    def publish_activity(json)
      activity = Activity.new(json)
      doc = @db.put(activity.to_hash)
      #puts activity.inspect
      #puts activity.to_h.inspect
      #puts JSON.generate(activity.to_hash).inspect
      #doc = @db.put json
      puts doc.inspect
    end
  end

  @@activity_service = ActivityService.new

  def self.service
    @@activity_service
  end
end

