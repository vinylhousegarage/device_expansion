require 'test_helper'

module Admin
  class SystemControllerTest < ActionDispatch::IntegrationTest
    def setup
      post admin_session_path
      assert_response :redirect
      assert_redirected_to new_user_path
    end

    # admin/system#reset_database のパスとフラッシュをテスト
    test 'should successfully post to reset_database path' do
      post reset_database_admin_system_path
      assert_response :redirect
      assert_redirected_to users_path
      follow_redirect!
      assert_response :success
      assert_flash_set(I18n.t('notices.data_reset'))
    end

    # admin/system#reload_database のパスとフラッシュをテスト
    test 'should successfully post to reload_database path' do
      post reload_database_admin_system_path
      assert_response :redirect
      assert_redirected_to users_path
      follow_redirect!
      assert_response :success
      assert_flash_set(I18n.t('notices.index_updated'))
    end
  end
end
