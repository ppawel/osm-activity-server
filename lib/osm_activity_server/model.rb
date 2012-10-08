require 'activitystreams'

module ActivityStreams
  class Object::Changeset < Object
  end

  class Object::Diary < Object
  end

  class Object::DiaryEntry < Object
  end

  class Object::UserGroup < Object
  end

  class Object::Website < Object
  end

  class Verb::Map < Verb
  end

  Activity.attr_optional(:to)
end
