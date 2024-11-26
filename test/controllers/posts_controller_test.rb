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
    assert_match 'Post was successfully deleted.', response.body

    assert_nil Post.find_by(id: @post.id)
  end
end
