require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test 'the truth' do
  #   assert true
  # end

  # Structを定数に定義
  USERS_STATS_STRUCT = Struct.new(:users_stats)

  # セッションデータを設定
  def setup
    initialize_user
    initialize_users_stats
  end

  private

  # 初期化を設定
  def initialize_user
    @user = users(:first_poster)
    sign_in_as(@user)
  end

  # スタブデータを設定
  def initialize_users_stats
    @users_stats = [
      { user_name: '投稿者１', post_count: 2, post_amount: 8_000 },
      { user_name: '投稿者２', post_count: 3, post_amount: 12_000 }
    ]
  end

  # newアクションをテスト
  test 'should get new post form' do
    users_stats_stubs = USERS_STATS_STRUCT.new(@users_stats)
    UserPostsStatsService.stubs(:new).returns(users_stats_stubs)
    get new_post_path
    assert_response :success
    users_posts_stats = UserPostsStatsService.new
    assert_equal @users_stats, users_posts_stats.users_stats
  end
end
