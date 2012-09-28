require 'couchdb-client'

module ActivityServer

class ActivityService
	attr_accessor :client
	attr_accessor :db

	def initialize
		self.client = CouchDB.connect :host => 'localhost', :port => 5984
		self.client.put 'activity_server'
		self.db = client['activity_server']
	end

	def publish_activity(json)
		doc = @db.put json
		puts doc.inspect
	end
end

@@activity_service = ActivityService.new

def self.service
	@@activity_service
end

end

