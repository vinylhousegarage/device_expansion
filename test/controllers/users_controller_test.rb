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
end
