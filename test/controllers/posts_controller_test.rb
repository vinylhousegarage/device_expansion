require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test 'the truth' do
  #   assert true
  # end

  # セッションデータを設定
  setup do
    @user = users(:first_poster)
    login_poster_as_json(@user)
  end

  # newアクションをテスト
  test 'should get new post form' do
    get new_post_path
    assert_response :success
  end
end
