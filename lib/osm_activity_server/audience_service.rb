require 'pg'
require 'osm_activity_server'

module AudienceService
  include ::ActivityServerLogger

  def get_users_for_activity(activity_item)
    conn = PGconn.open(:host => 'localhost', :dbname => 'apidb', :user => 'ppawel', :password => 'aa')
    users = []

    activity_item.to.each do |to|
      @@log.debug " Examining recipient #{to}"

      if to.object_type.to_s == 'user_group'
        case to.id.to_s
          when 'all' then users += get_all_users(conn)
          when 'friends' then users += get_friends(conn, activity_item)
        end
      end
    end

    users.uniq
  end

  def get_all_users(conn)
    conn.query('SELECT id FROM users').collect {|row| row['id']}
  end

  def get_friends(conn, activity_item)
    conn.query("SELECT friend_user_id FROM friends WHERE user_id = #{activity_item.actor.id}").collect {|row| row['friend_user_id']}
  end
end
