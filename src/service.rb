require 'couchdb-client'
require 'json'

require './model'

module ActivityServer

class ActivityService
  attr_accessor :client
  attr_accessor :db

  def initialize
    @client = CouchDB.connect(:host => 'localhost', :port => 5984)
    #@client.put('activities')
    @db = client['activities']
    doc = @db.find('_design/activities')
    if doc
      @db.delete('_design/activities', doc['_rev'])
      @db.put(JSON[File.open('activities.json', 'rb').read])
    else
      @db.put(JSON[File.open('activities.json', 'rb').read])
    end
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

