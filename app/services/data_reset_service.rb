class DataResetService
  def self.call
    Rails.application.load_seed
  end
end
