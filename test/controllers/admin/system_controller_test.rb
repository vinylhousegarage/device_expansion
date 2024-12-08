require 'test_helper'

module Admin
  class SystemControllerTest < ActionDispatch::IntegrationTest
    def setup
      post admin_session_path
      assert_response :redirect
      assert_redirected_to users_path
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
  end

  test 'should get user_posts'
    @user = users(:first_poster)
    get admin_user_posts_path(@user)
    assert_response :success
  end
end
