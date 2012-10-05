##
# This is a standard Rails model class - it is used to store activities in a database. Attributes of this class
# represent a subset of {ActivityStreams::Activity}[https://github.com/nov/activitystreams/blob/master/lib/activitystreams/activity.rb] attributes.
#
class Activity < ActiveRecord::Base
  ##
  # Transfers data from given activity item attributes to this instance's attributes.
  #
  def from_activity_item(activity_item)
    self.published_at = activity_item.published
    self.actor_type = activity_item.actor.object_type.to_s
    self.actor_id = activity_item.actor.id.to_s
    self.actor_display_name = activity_item.actor.display_name
    self.actor_url = activity_item.actor.url.to_s
    self.object_type = activity_item.object.object_type.to_s
    self.object_id = activity_item.object.id.to_s
    self.object_display_name = activity_item.object.display_name
    self.object_url = activity_item.object.url.to_s
    self.target_type = activity_item.target.object_type.to_s
    self.target_id = activity_item.target.id.to_s
    self.target_display_name = activity_item.target.display_name
    self.target_url = activity_item.target.url.to_s
    self.verb = activity_item.verb.to_s
    self.title = activity_item.title
    self.content = activity_item.content
  end
end
