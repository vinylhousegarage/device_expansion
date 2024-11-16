require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test 'the truth' do
  #   assert true
  # end

  # 初期データを挿入しユーザーを取得
  setup do
    @user = users(:first_poster)
    @post = posts(:first_post)
  end

  # name属性のバリデーションをテスト
  test 'invalid post with empty or space name' do
    invalid_names = ['', ' ']
    invalid_names.each do |invalid_name|
      @post.name = invalid_name
      assert_not @post.valid?, "Invalid name: '#{invalid_name}'"
      expected_message = I18n.t('activerecord.errors.models.post.attributes.amount.blank')
      assert_includes @post.errors[:amount], expected_message
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
        amount: 5000,
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

  # Post model のスコープのテスト
  test 'only posts of user' do
    posts = Post.by_user(@user.id)
    assert_includes posts, @post
  end

  # 存在しないユーザーの投稿を取得した場合は空の結果を返す
  non_existent_user_id = -1

  test 'empty for non-existent user' do
    posts = Post.by_user(non_existent_user_id)
    assert_empty posts
  end
end
