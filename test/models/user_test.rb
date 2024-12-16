require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test 'the truth' do
  #   assert true
  # end

  # 初期データを挿入しユーザーを取得
  setup do
    @user = users(:first_poster)
    @session = { user_id: @user.id }
  end

  # Postインスタンスの初期属性を設定
  def new_post(attributes = {})
    Post.new({
      name: '試験 氏名',
      amount: 10_000,
      address: '市町村1丁目-nameⅡ',
      tel: '0123456789',
      others: '供花:20,000円(2段)',
      user: @user
    }.merge(attributes))
  end

  # UserがPostを複数持てるかのテスト
  test 'should have many postsj' do
    post1 = posts(:first_post)
    post2 = posts(:second_post)

    assert_equal 2, @user.posts.size
    assert_includes @user.posts, post1
    assert_includes @user.posts, post2
  end
end
