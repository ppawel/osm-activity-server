require 'pg'

module AudienceService
  def get_users_for_activity(activity_item)
    conn = PGconn.open(:host => 'localhost', :dbname => 'apidb', :user => 'ppawel', :password => 'aa')
    conn.query('SELECT id FROM users').collect {|row| row['id']}
  end
end
