require 'test_helper'

class ApplicationControllerIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_poster)
    sign_in_as(@user)
  end

  # find_params_idメソッドのテスト
  test 'find_params_id should find user based on params[:id]' do
    get login_poster_redirect_user_path(id: @user.id)
    assert_response :success
    fetch_url_pattern = %r{fetch\('/users/#{@user.id}/login_poster'}
    assert_match fetch_url_pattern, response.body
  end

  # redirect_with_noticeメソッドのパスをテスト
  test 'redirect_with_notice redirects to the correct path' do
    delete reset_database_users_path
    assert_response :redirect
    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
  end

  # redirect_with_noticeメソッドのフラッシュメッセージを確認
  test 'redirect_with_notice sets flash and displays in redirected view' do
    delete reset_database_users_path
    assert_response :redirect
    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
    assert_flash(:notice, I18n.t('notices.data_reset'))
  end
end
