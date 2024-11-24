require 'test_helper'

class LoginFormViewTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:first_poster)
    post login_form_user_path(@user.id)
    assert_response :success
  end

  test 'should display login_form page with correct elements' do
    assert_select 'svg', true, 'QRコードが表示されていません'
    assert_select 'a[href=?]', login_poster_redirect_user_path(@user.id), text: nil
    assert_select 'form[action=?][method=?]', new_user_path, 'get'
  end

  test 'should navigate to login_poster_redirect path successfully' do
    get login_poster_redirect_user_path(@user.id)
    assert_response :success
  end

  test 'should navigate to new_user path successfully' do
    get new_user_path
    assert_response :success
  end
end
