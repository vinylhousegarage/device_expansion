require 'test_helper'

class QrCodeControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper
  # test "the truth" do
  #   assert true
  # end

  # QRコードの表示をテスト
  test 'should post to login form and generate QR code' do
    @user = users(:first_poster)
    svg_expected_count = 1
    post login_form_qr_code_path(@user.id)
    assert_response :success
    assert_select 'svg', svg_expected_count
  end
end
