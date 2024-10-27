require 'test_helper'
require 'capybara/rails'
require 'capybara/minitest'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: { headless: true }

  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = 3000

  Capybara.default_max_wait_time = 5
end
