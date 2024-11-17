require 'test_helper'

class DataResetServiceTest < ActiveSupport::TestCase
  test 'it calls Rails.application.load_seed' do
    Rails.application.expects(:load_seed).once

    DataResetService.call
  end
end
