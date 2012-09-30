# This module contains a simple object data model for JSON Activity Streams specification.
# See http://activitystrea.ms/specs/json/1.0/ for details.

module ActivityServer
  def self.recursive_to_h(hash)
    Hash[hash.collect {|k, v| [k, v.respond_to?(:to_hash) ? recursive_to_h(v.to_hash) : v]}]
  end

  class Object
    attr_accessor :author
    attr_accessor :content
    attr_accessor :id
    attr_accessor :objectType

    def initialize(json)
      @author = Object.new(json['author']) if json.has_key?('author')
      @content = json['content'] if json.has_key?('content')
      @id = json['id'] if json.has_key?('id')
      @objectType = json['objectType'] if json.has_key?('objectType')
    end

    def to_hash
      result = {}
      instance_variables.each do |var_name|
        result[var_name.to_s.gsub('@', '')] = instance_variable_get(var_name)
      end
      result
    end
  end

  class Activity
    attr_accessor :actor
    attr_accessor :content
    attr_accessor :id
    attr_accessor :object
    attr_accessor :target
    attr_accessor :title
    attr_accessor :to
    attr_accessor :verb

    def initialize(json)
      @actor = Object.new(json['actor']) if json.has_key?('actor')
      @content = json['content'] if json.has_key?('content')
      @id = json['id'] if json.has_key?('id')
      @object = Object.new(json['object']) if json.has_key?('object')
      @target = Object.new(json['target']) if json.has_key?('target')
      @title = json['title'] if json.has_key?('title')
      @to = json['to'].collect {|o| Object.new(o)} if json.has_key?('to')
      @verb = json['verb']
    end

    def to_hash
      result = {}
      instance_variables.each do |var_name|
        var = instance_variable_get(var_name)
        var = var.collect {|element| element.to_hash} if var.class.name == 'Array'
        var = var.to_hash if var.respond_to?('to_hash')
        result[var_name.to_s.gsub('@', '')] = var
      end
      result
    end
  end
end

