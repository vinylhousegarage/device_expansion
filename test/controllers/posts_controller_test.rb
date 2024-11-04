require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test 'the truth' do
  #   assert true
  # end

  # セッションデータを設定
  setup do
    @user = users(:first_poster)
    log_in_as(@user)
  end

  # ログインヘルパーメソッドを定義
  def log_in_as(user)
    post login_poster_user_path(user.id), params: { id: user.id }, as: :json
  end

  # newアクションをテスト
  test 'should get new post form' do
    get new_post_path
    assert_response :success
  end
end
