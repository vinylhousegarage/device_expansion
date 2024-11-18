require 'test_helper'

class LoginFormViewTest < ActionDispatch::IntegrationTest
  test 'should display QR code and navigate correctly' do
    user = users(:first_poster)

    post login_form_user_path(user_id: user.id)
    assert_response :success

    assert_select 'svg', true, 'QRコードが表示されていません'
    assert_select 'a[href=?]', login_poster_redirect_user_path(user_id: user.id), text: nil
    assert_select 'form[action=?][method=?]', new_user_path, 'get'

    get login_poster_redirect_user_path(user_id: user.id)
    follow_redirect!
    assert_response :success

    get new_user_path
    assert_response :success
  end
end
