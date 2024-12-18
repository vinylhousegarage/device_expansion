require 'test_helper'

class QrCodeLoginFormViewTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_poster)
    get login_form_qr_code_path(@user)
    assert_response :success
  end

  test 'should display login_form page with correct elements' do
    assert_select 'svg', true, 'QRコードが表示されていません'
    assert_select 'a[href=?]', handle_login_qr_code_path(@user), text: nil
    assert_select 'form[action=?][method=?]', new_user_path, 'get'
  end

  test 'should navigate to handle_login path successfully' do
    get handle_login_qr_code_path(@user)
    assert_response :success
  end

  test 'should navigate to new_user path successfully' do
    get new_user_path
    assert_response :success
  end
end
