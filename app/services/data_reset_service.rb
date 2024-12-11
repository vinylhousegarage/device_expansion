class DataResetService
  def self.call
    reset_database
    Rails.application.load_seed
  end

  private

  def self.reset_database
    User.destroy_all
    %w[users posts].each do |table_name|
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{table_name}_id_seq RESTART WITH 1")
    end
  end
end
