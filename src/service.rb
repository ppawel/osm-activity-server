require 'couchdb-client'
require './model'

module ActivityServer

class ActivityService
  attr_accessor :client
  attr_accessor :db

  def initialize
    @client = CouchDB.connect(:host => 'localhost', :port => 5984)
    @db = client['activity_server']
    #@client.put('activity_server')
  end

  def publish_activity(json)
    activity = Activity.new(json)
    #puts activity.inspect
    #puts activity.to_h.inspect
    puts JSON.generate(activity.to_hash).inspect
    #doc = @db.put json
    #puts doc.inspect
  end
end

@@activity_service = ActivityService.new

def self.service
  @@activity_service
end

end

