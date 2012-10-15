require 'activitystreams'

module ActivityStreams
  class Activity
    attr_optional :bbox

    def geom
      object.geom if object.respond_to?(:geom)
    end
  end

  class Object::Changeset < Object
    attr_accessor :geom

    def initialize(attributes)
      super(attributes)
      @geom = attributes[:geom]
    end
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
