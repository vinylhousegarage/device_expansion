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
      assert_not @post.valid?, "Post with name '#{invalid_name}' should be invalid"
      assert_includes @post.errors[:name], "can't be blank"
    end
  end

  # amount属性のバリデーションをテスト
  test 'invalid post with empty, space or negative amount' do
    invalid_amounts = ['', ' ', -1000]
    invalid_amounts.each do |invalid_amount|
      @post.amount = invalid_amount
      assert_not @post.valid?, "Post with amount '#{invalid_amount}' should be invalid"
      if invalid_amount.to_s.strip.empty?
        assert_includes @post.errors[:amount], "can't be blank", 'Amount should be invalid when blank'
      else
        assert_includes @post.errors[:amount], 'must be greater than or equal to 0', 'Amount should be greater than or equal to 0'
      end
    end
  end

  # Postインスタンスの新規生成テスト
  test 'creates post with valid attributes' do
    new_post = Post.new(
      name: '新しい氏名',
      amount: 5000,
      address: '新しい市町村1丁目',
      tel: '0987654321',
      others: '新しい供花:10,000円',
      user: @user
    )
    assert new_post.valid?, 'Post should be valid with correct attributes'
    assert_difference('Post.count', 1) do
      new_post.save
    end
  end

  # Postインスタンスのアソシエーションテスト
  test 'post belongs to correct user' do
    assert_equal @user, @post.user, "Post's user should be the user with name '投稿者１'"
    assert @post.save, 'Post should be saved successfully'
  end
end
