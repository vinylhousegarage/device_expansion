require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # 初期データを挿入しユーザーを取得
  setup do
    @user = User.find_or_create_by(name: "ゲスト１")
  end

  # Postインスタンスの初期属性を設定
  def new_post(attributes = {})
    Post.new({
      name: "試験 氏名",
      amount: 10000,
      address: "市町村1丁目-nameⅡ",
      tel: "0123456789",
      others: "供花:20,000円(2段)",
      user: @user,
    }.merge(attributes))
  end

  # name属性のバリデーションをテスト
  test "invalid post with empty or space name" do
    invalid_names = ["", " "]

    invalid_names.each do |invalid_name|
      post = new_post(name: invalid_name)
      assert_not post.valid?, "Post with name '#{invalid_name}' should be invalid"
      assert_includes post.errors[:name], "can't be blank"
    end
  end

  # amount属性のバリデーションをテスト
  test "invalid post with empty, space or negative amount" do
    invalid_amounts = ["", " ", -1000]
    invalid_amounts.each do |invalid_amount|
      post = new_post(amount: invalid_amount)
      assert_not post.valid?, "Post with amount '#{invalid_amount}' should be invalid"
      if invalid_amount.to_s.strip.empty?
        assert_includes post.errors[:amount], "can't be blank", "Amount should be invalid when blank"
      else
        assert_includes post.errors[:amount], "must be greater than or equal to 0", "Amount should be greater than or equal to 0"
      end
    end
  end

  # Postインスタンスの新規生成テスト
  test "creates post with valid schema and user_id" do
    assert_not_nil @user, "User with name 'ゲスト１' not found"
    post = new_post
    assert post.valid?, "Post should be valid with correct attributes"
    assert_difference('Post.count', 1) do
      post.save
    end
  end

  # Postインスタンスのアソシエーションテスト
  test "post belongs to author" do
    post = new_post
    assert_equal @user, post.user, "Post's user should be the user with name 'ゲスト１'"
    assert post.save, "Post should be saved successfully"
  end
end


