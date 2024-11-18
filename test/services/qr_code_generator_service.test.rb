require 'test_helper'

class QRCodeGeneratorTest < ActiveSupport::TestCase
  test 'should generate QR code SVG for login poster' do
    user = users(:first_poster)
    svg = QRCodeGenerator.generate_for_login_poster(user)

    assert svg.include?('<svg')
    assert svg.include?('</svg>')
  end
end
