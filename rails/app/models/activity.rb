class Activity < ActiveRecord::Base
  def from_activity_model(activity_model)
    self.published_at = activity_model.published
    self.actor_type = activity_model.actor.object_type.to_s
    self.actor_id = activity_model.actor.id.to_s
    self.actor_name = activity_model.actor.display_name
    self.object_type = activity_model.object.object_type.to_s
    self.object_id = activity_model.object.id.to_s
    self.object_name = activity_model.object.display_name
    self.target_type = activity_model.target.object_type.to_s
    self.target_id = activity_model.target.id.to_s
    self.target_name = activity_model.target.display_name
    self.verb = activity_model.verb
    self.title = activity_model.title
    self.content = activity_model.content
  end
end
