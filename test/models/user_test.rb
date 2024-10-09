require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # 初期データを挿入しユーザーを取得
  setup do
    @user = users(:guest_1)
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
    post1 = posts(:post_1)
    post2 = posts(:post_2)

    assert_equal 2, @user.posts.size
    assert_includes @user.posts, post1
    assert_includes @user.posts, post2
  end

  # loginアクションのテスト
  test "should get admin user from fixture" do
    admin_user = users(:admin)
    assert_equal "集計担当", admin_user.name
  end

  # newアクション実行時のセッションID の空チェック
  test "should reset session in new" do
    get :new
    assert_nil session[:user_id]
  end
end



