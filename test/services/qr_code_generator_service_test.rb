require 'test_helper'

class QrCodeGeneratorServiceTest < ActiveSupport::TestCase
  test 'should generate QR code SVG for qr_code_request' do
    user = users(:first_poster)
    svg = QrCodeGeneratorService.generate_qr_code(user)

    assert svg.include?('<svg')
    assert svg.include?('</svg>')
  end
end
