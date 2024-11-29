require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # テスト用の初期データを設定
  def setup
    @user = users(:first_poster)
    @post = posts(:first_post)
    sign_in_as(@user)
  end

  # find_posts_by_paramsメソッドをテスト
  test 'should successfully delete the correct post' do
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end

    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_nil Post.find_by(id: @post.id)
  end

  # createアクションの正常時をテスト
  test 'should create post successfully' do
    post login_poster_qr_code_path(@user)
    assert_response :success
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { name: 'テストユーザー', amount: 3_000, address: '東京都', tel: '08012345678', others: '備考' } }
    end
    assert_redirected_to new_post_path
  end

  # createアクションの異常時をテスト
  test 'should not create post with invalid attributes' do
    post login_poster_qr_code_path(@user)
    assert_response :success
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { name: '', amount: nil, address: '', tel: 'abc123', others: '' } }
    end
    assert_response :unprocessable_entity
  end
end
