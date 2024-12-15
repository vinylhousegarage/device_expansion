require 'test_helper'

class QrCodeRequestUrlGeneratorServiceTest < ActiveSupport::TestCase
  test 'should generate correct login poster redirect URL' do
    user = users(:first_poster)
    url = QrCodeRequestUrlGeneratorService.generate_qr_code_request_url(user)

    expected_url = Rails.application.routes.url_helpers.qr_code_request_qr_code_url(
      user,
      host: 'https://device-expansion.onrender.com'
    )

    assert_equal expected_url, url
  end
end
