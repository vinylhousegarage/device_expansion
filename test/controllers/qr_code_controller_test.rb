require 'test_helper'

class QrCodeControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:first_poster)
  end

  # QRコードの表示をテスト
  test 'should post to login form and generate QR code' do
    svg_expected_count = 1
    get login_form_qr_code_path(@user)
    assert_response :success
    assert_select 'svg', svg_expected_count
  end

  # qr_code_request のパスをテスト
  test 'should handle valid handle_login' do
    get handle_login_qr_code_path(@user)
    assert_response :redirect
  end
end
