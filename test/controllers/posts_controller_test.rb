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
    post login_form_user_path(user.id)
  end

  # newアクションをテスト
  test 'should get new post form' do
    get new_post_path

    assert_response :success

    assert_select 'form[action=?][method=?]', posts_path, 'post' do
      assert_select 'input[type=text][name=?]', 'post[name]'
      assert_select 'input[type=number][name=?]', 'post[amount]'
      assert_select 'input[type=text][name=?]', 'post[address]'
      assert_select 'input[type=text][name=?]', 'post[tel]'
      assert_select 'input[type=text][name=?]', 'post[others]'
    end
  end
end
