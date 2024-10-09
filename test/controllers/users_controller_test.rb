require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # 管理者の"集計担当"ユーザーでログインするテスト
  test "should log in admin user and redirect to users path" do
    admin_user = users(:admin)
    post login_users_path
    assert_equal admin_user.id, session[:user_id]
    assert_redirected_to users_path
  end

  # newアクション実行時のセッションID の空チェック
  test "should reset session in new" do
    get new_user_path
    assert_nil session[:user_id]
  end

  # newアクションのテスト
  test "should get new and reset session and assign users" do
    get new_user_path
    assert_response :success
    expected_users = User.where(name: User::GUEST_NAMES)
    assert_equal expected_users.pluck(:id), assigns(:users).pluck(:id)
  end
end
