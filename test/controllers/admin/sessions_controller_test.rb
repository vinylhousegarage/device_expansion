require 'test_helper'

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    post admin_session_path
    assert_response :redirect
    assert_redirected_to users_path
  end

  # 管理者ログアウトアクションのパスとフラッシュをテスト
  test 'should successfully post to admin logout path with flash' do
    delete admin_session_path
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_flash_set(I18n.t('notices.logged_out'))
  end
end
