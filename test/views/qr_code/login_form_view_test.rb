require 'test_helper'

class QrCodeLoginFormViewTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_poster)
    post login_form_qr_code_path(@user.id)
    assert_response :success
  end

  test 'should display login_form page with correct elements' do
    assert_select 'svg', true, 'QRコードが表示されていません'
    assert_select 'a[href=?]', qr_code_request_qr_code_path(@user.id), text: nil
    assert_select 'form[action=?][method=?]', new_user_path, 'get'
  end

  test 'should navigate to login_poster_redirect path successfully' do
    get qr_code_request_qr_code_path(@user.id)
    assert_response :redirect
  end

  test 'should navigate to new_user path successfully' do
    get new_user_path
    assert_response :success
  end
end
