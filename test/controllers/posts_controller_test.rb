require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test 'the truth' do
  #   assert true
  # end

  # セッションデータを設定
  setup do
    @user = users(:first_poster)
    @post = posts(:first_post)
    log_in_as(@user)
  end

  # ログインヘルパーメソッドを定義
  def log_in_as(user)
    @request.session[:user_id] = user.id
  end

  # newアクションをテスト
  test 'should get new for existing user' do
    get new_post_path

    assert_response :success
    assert_select 'form[action=?]', posts_path
    assert_select 'div.post', text: @post.title
  end
end
