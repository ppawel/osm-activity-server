require 'activitystreams'

module ActivityStreams
  class Object::Diary < Object
  end

  class Object::DiaryEntry < Object
  end

  class Object::UserGroup < Object
  end

  Activity.attr_optional(:to)
end
