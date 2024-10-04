require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # 初期データを挿入しユーザーを取得
  setup do
    @user = User.find_by(name: "ゲスト１")
  end

  # name属性のバリデーションをテスト
  test "invalid post with empty or space name" do
    invalid_names = ["", " "]

    invalid_names.each do |invalid_name|
      post = Post.new(name: invalid_name, user_id: @user.id, amount: 10000, address: "市町村1丁目-test", tel: "0123456789", others: "供花:20,000円(2段)")
      assert_not post.valid?, "Post with name '#{invalid_name}' should be invalid"
      assert_includes post.errors[:name], "can't be blank or contain only spaces"
    end
  end

  # amount属性のバリデーションをテスト
  test "invalid post with empty, space or negative amount" do
    invalid_amounts = ["", " ", -1000]

    invalid_amounts.each do |invalid_amount|
      post = Post.new(name: "試験 氏名", user_id: @user.id, amount: invalid_amount, address: "市町村1丁目-test", tel: "0123456789", others: "供花:20,000円(2段)")
      assert_not post.valid?, "Post with amount '#{invalid_amount}' should be invalid"
      assert_includes post.errors[:amount], "must be a positive number"
    end
  end

  # Postインスタンスの新規生成テスト
  test "creates post with valid schema and user_id" do
    assert_not_nil @user, "User with name 'ゲスト１' not found"
    post = Post.new(name: "試験 氏名", user_id: @user.id, amount: 10000, address: "市町村1丁目-test", tel: "0123456789", others: "供花:20,000円(2段)")
    assert post.valid?, "Post should be valid with correct attributes"
    assert_difference('Post.count', 1) do
      post.save
    end
  end
end
