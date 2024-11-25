require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test 'the truth' do
  #   assert true
  # end

  # 初期データを挿入しユーザーを取得
  def setup
    @user = users(:first_poster)
    @admin_user = users(:admin)
    @post = posts(:first_post)
    @admin_post1 = posts(:third_post)
    @admin_post2 = posts(:fourth_post)
  end

  # name属性のバリデーションをテスト
  test 'invalid post with empty or space name' do
    invalid_names = ['', ' ']
    invalid_names.each do |invalid_name|
      @post.name = invalid_name
      assert_not @post.valid?, "Invalid name: '#{invalid_name}'"
      expected_message = I18n.t('activerecord.errors.models.post.attributes.name.blank')
      assert_includes @post.errors[:name], expected_message
    end
  end

  # amount属性のバリデーションをテスト
  test 'invalid post with empty, space or negative amount' do
    invalid_amounts = ['', ' ', -1000]
    invalid_amounts.each do |invalid_amount|
      @post.amount = invalid_amount
      assert_not @post.valid?, "Invalid amount: '#{invalid_amount}'"
      expected_message = if invalid_amount.to_s.strip.empty?
                           I18n.t('activerecord.errors.models.post.attributes.amount.blank')
                         else
                           I18n.t('activerecord.errors.models.post.attributes.amount.greater_than_or_equal_to')
                         end
      assert_includes @post.errors[:amount], expected_message, 'Amount validation failed'
    end
  end

  # Postインスタンスの新規生成テスト
  test 'creates post with valid attributes' do
    assert_difference('Post.count', 1) do
      Post.create!(
        name: '新しい氏名',
        amount: 5_000,
        address: '新しい市町村1丁目',
        tel: '0987654321',
        others: '新しい供花:10,000円',
        user: @user
      )
    end
  end

  # Postインスタンスのアソシエーションテスト
  test 'post belongs to correct user' do
    assert_equal @user, @post.user, "Post's user should be the user with name '投稿者１'"
  end

  # user_post_indexメソッドをテスト
  test 'user_post_index returns correct position within user posts' do
    assert_equal 1, @admin_post1.user_post_index, 'Post 1 should have index 1 for the user'
    assert_equal 2, @admin_post2.user_post_index, 'Post 2 should have index 2 for the user'
  end

  # user_post_indexメソッドの破壊的変更後をテスト
  test 'user_post_index adjusts when posts are deleted' do
    @admin_post1.destroy
    assert_equal 1, @admin_post2.user_post_index, 'Post 2 should move to index 1 after Post 1 is deleted'
  end

  # post = nil をテスト
  test 'user_post_index returns nil if user.posts is nil' do
    user = User.new # posts が未設定のユーザー
    post = Post.new(user: user)
    assert_nil post.user_post_index, 'user_post_index should return nil if user.posts is nil'
  end
end
