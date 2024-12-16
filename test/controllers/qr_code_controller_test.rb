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

  # qr_code_request 正常系: 有効なユーザーIDを渡した場合
  test 'should handle valid qr_code_request' do
    user = users(:second_poster)
    get qr_code_request_path(id: user.id)
    assert_response :redirect
  end

  # qr_code_request 異常系1: id パラメータが欠落している場合
  test 'should return bad request when id is missing' do
    get qr_code_request_path
    assert_response :bad_request
    assert_match '<h3>最初からやり直してください</h3>', response.body
  end
end
