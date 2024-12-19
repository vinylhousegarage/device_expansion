require 'test_helper'

class HandleLoginUrlGeneratorServiceTest < ActiveSupport::TestCase
  test 'should generate correct qr_code_request URL' do
    user = users(:first_poster)
    url = HandleLoginUrlGeneratorService.generate_handle_login_url(user)

    expected_url = Rails.application.routes.url_helpers.handle_login_qr_code_url(
      user,
      host: 'https://device-expansion.onrender.com'
    )

    assert_equal expected_url, url
  end
end
