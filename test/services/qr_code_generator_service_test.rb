require 'test_helper'

class QrCodeGeneratorServiceTest < ActiveSupport::TestCase
  test 'should generate QR code SVG for login poster' do
    user = users(:first_poster)
    url = LoginPosterUrlGeneratorService.generate_login_poster_url(user)
    svg = QrCodeGeneratorService.generate_for_login_poster(user)

    # Debugging logs
    Rails.logger.debug "Expected URL: #{url}"
    Rails.logger.debug "Generated SVG: #{svg}"

    # Asserts with meaningful messages
    assert_not_nil url, "URL should not be nil"
    assert_not_nil svg, "SVG should not be nil"
    assert svg.include?(url), "Expected SVG to include URL, but URL was: #{url}"
  end
end
