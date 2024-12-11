class DataResetService
  def self.call
    reset_database
    Rails.application.load_seed
  end

  private

  def self.reset_database
    User.destroy_all
  end
end
