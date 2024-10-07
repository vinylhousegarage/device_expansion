require 'test_helper'

class UserTest < ActiveSupport::TestCase
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

  # UserがPostを複数持てるかのテスト
  test "should have many posts" do
    post1 = new_post
    post2 = new_post(amount: 20000)

    @user.posts << post1
    @user.posts << post2

    assert_equal 2, @user.posts.size
    assert_includes @user.posts, post1
    assert_includes @user.posts, post2
  end
end
