require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test 'the truth' do
  #   assert true
  # end

  # セッションデータを設定
  setup do
    @user = users(:first_poster)
    log_in_as(@user)
    session[:user_id] = @user.id
  end

  # ログインヘルパーメソッドを定義
  def log_in_as(user)
    post login_form_user_path(user.id)
  end

  # newアクションをテスト
  test 'should get new post form' do
    get new_post_path
    assert_response :success
  end
end
