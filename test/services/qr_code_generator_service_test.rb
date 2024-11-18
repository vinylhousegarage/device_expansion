require 'test_helper'

class QrCodeGeneratorServiceTest < ActiveSupport::TestCase
  test 'should generate QR code SVG for login poster' do
    user = users(:first_poster)
    url = LoginPosterUrlGeneratorService.generate_login_poster_url(user)
    svg = QrCodeGeneratorService.generate_for_login_poster(user)

    assert svg.include?('<svg')
    assert svg.include?('</svg>')
  end
end
