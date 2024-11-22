require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test 'the truth' do
  #   assert true
  # end

  # Structを定数に定義
  USER_STATS_STRUCT = Struct.new(:user_stats)

  # セッションデータを設定
  def setup
    initialize_user
    initialize_user_stats
    stub_services
  end

  private

  # 初期化を設定
  def initialize_user
    @user = users(:first_poster)
    sign_in_as(@user)
  end

  # スタブデータを設定
  def initialize_user_stats
    @user_stats = [
      { user_name: '投稿者１', post_count: 2, post_amount: 8_000 },
      { user_name: '投稿者２', post_count: 3, post_amount: 12_000 }
    ]
  end

  # サービスクラスをスタブ化
  def stub_services
    user_stats_stub = USER_STATS_STRUCT.new(@user_stats)
    UserPostsStatsService.stubs(:new, user_stats_stub) do
      get new_post_path
    end
  end

  # newアクションをテスト
  test 'should get new post form' do
    get new_post_path
    assert_response :success
  end
end
