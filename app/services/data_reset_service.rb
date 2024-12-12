class DataResetService
  def self.call
    reset_database
  end

  def self.reset_database
    ActiveRecord::Base.connection.execute('TRUNCATE TABLE posts, users RESTART IDENTITY CASCADE')

    Rails.application.load_seed
  end
end
