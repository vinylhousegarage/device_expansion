require 'test_helper'

class Admin::SystemControllerTest < ActionDispatch::IntegrationTest
  def setup
    post admin_login_path
    assert_response :redirect
    assert_redirected_to users_path
  end

  # admin/system#logout のパスとフラッシュをテスト
  test 'should successfully post to logout admin path' do
    delete admin_logout_path
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_flash_set(I18n.t('notices.data_reset'))
  end

  # admin/system#reset_database のパスとフラッシュをテスト
  test 'should successfully post to reset_database path' do
    delete admin_reset_database_path
    assert_response :redirect
    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
    assert_flash_set(I18n.t('notices.data_reset'))
  end
end