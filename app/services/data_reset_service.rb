class DataResetService
  def self.call
    reset_database
  end

  def self.reset_database
    Post.destroy_all
    ActiveRecord::Base.connection.execute("ALTER SEQUENCE posts_id_seq RESTART WITH 1")
  end
end
