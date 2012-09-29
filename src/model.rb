# This module contains a simple object data model for JSON Activity Streams specification.
# See http://activitystrea.ms/specs/json/1.0/ for details.

module ActivityServer
  def self.recursive_to_h(hash)
    Hash[hash.collect {|k, v| [k, v.respond_to?(:to_hash) ? recursive_to_h(v.to_hash) : v]}]
  end

  class Object
    attr_accessor :props

    def initialize(json)
      @props = {}
      @props[:author] = Object.new(json['author']) if json.has_key?('author')
      @props[:content] = json['content']
      @props[:id] = json['id']
    end

    def to_hash
      ActivityServer::recursive_to_h(@props)
    end
  end

  class Activity
    attr_accessor :props

    def initialize(json)
      @props = {}
      @props[:actor] = Object.new(json['actor'])
      @props[:content] = json['content']
      @props[:id] = json['id']
      @props[:object] = Object.new(json['object']) if json.has_key?('object')
      @props[:target] = Object.new(json['target']) if json.has_key?('target')
      @props[:title] = json['title']
      @props[:verb] = json['verb']
    end

    def to_hash
      ActivityServer::recursive_to_h(@props)
    end
  end
end

