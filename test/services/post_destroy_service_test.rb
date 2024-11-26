require 'test_helper'

class PostDestroyServiceTest < ActiveSupport::TestCase
  def setup
    @user = users(:second_poster)
    @post = posts(:sixth_post)
    @service = PostDestroyService.new(@post)
  end

  # ユーザーに紐づく全ての投稿が削除された場合のリダイレクトをテスト
  test 'should return :new_post_path when post is destroyed and user has no posts left' do
    @post.stubs(:destroy).returns(true)
    @user.posts.stubs(:count).returns(0)
    result = @service.call
    assert_equal :new_post_path, result[:path]
  end

  # ユーザーに紐づく投稿が存在する場合のリダイレクトをテスト
  test 'should return :user_path when post is destroyed and user has other posts' do
    @post.stubs(:destroy).returns(true)
    @user.posts.stubs(:count).returns(1)
    result = @service.call
    assert_equal :user_path, result[:path]
  end

  # 投稿の削除が失敗した場合のリダイレクトをテスト
  test 'should return :new_post_path when post destruction fails' do
    @post.stubs(:destroy).returns(false)
    result = @service.call
    assert_equal :new_post_path, result[:path]
  end
end
