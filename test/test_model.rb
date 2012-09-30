$:.unshift '../src'

require 'json'
require 'test/unit'

require 'model'

class ModelTest < Test::Unit::TestCase
  def get_diary_entry_activity
    json = JSON.parse(File.open('diary_entry_activity.json', 'rb').read)
    ActivityServer::Activity.new(json)
  end

  def test_parse_activity
    activity = get_diary_entry_activity
    assert_equal('diary', activity.target.objectType)
  end

  def test_activity_to_hash
    activity = get_diary_entry_activity
    hash = activity.to_hash
    assert_equal('Hash', hash.class.name)
    assert_equal('Hash', hash['object'].class.name)
    assert_equal('Array', hash['to'].class.name)
    assert_equal('Hash', hash['to'][0].class.name)
    assert_equal('user group', hash['to'][0]['objectType'])
    assert_equal('all', hash['to'][0]['id'])
  end
end

